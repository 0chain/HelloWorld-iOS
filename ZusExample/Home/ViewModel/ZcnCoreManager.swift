//
//  ZcncoreManager.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation
import Zcncore

class ZcncoreManager: NSObject, ObservableObject {
    
    static let shared = ZcncoreManager()

    private static var network: NetworkConfig = Network.demoZus.config
    static var zboxStorageSDKHandle : SdkStorageSDK? = nil
    
    @Published var processing: Bool = false
    @Published var toast: ZCNToast.ZCNToastType = .progress("Creating Wallet...")

    func initialize() {
        do {
            if let networkScheme = Utils.get(key: .network) as? String, let network = Network(rawValue: networkScheme) {
                ZcncoreManager.network = network.config
            }
            try initialiseSDK()
            setWalletInfo()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    class func configString() throws -> String? {
        let encoder: JSONEncoder = JSONEncoder()
        let data = try encoder.encode(self.network)
        return String(data: data, encoding: .utf8)
    }
    
    func initialiseSDK() throws {
        var error: NSError? = nil
        let logPath = Utils.logPath()
        ZcncoreSetLogFile(logPath.path, true)
        
        let jsonData = try JSONEncoder().encode(ZcncoreManager.network)
        let configString = String(data: jsonData, encoding: .utf8)!
        let wallet = Utils.get(key: .walletJSON) as? String
        
        ZcncoreInit(configString, &error)
        
        ZcncoreManager.zboxStorageSDKHandle = SdkInitStorageSDK(wallet, configString, &error)
        
        if let error = error {
            throw error
        }
    }
    
    func createWallet() {
        self.toast = .progress("Creating Wallet ...")
        self.processing = true
        
        var error: NSError? = nil
        ZcncoreCreateWallet(self, &error)
        
        if let error = error {
            self.onWalletCreateFailed(error: error.localizedDescription)
        }
    }
    
    func createAllocation() {
        DispatchQueue.global().async {
            do {
                let allocation = try ZcncoreManager.zboxStorageSDKHandle?.createAllocation(2, parityshards: 2, size: 214748364, expiration: Int64(Date().timeIntervalSince1970 + 2592000), lock: "10000000000")
               // VultViewModel.zboxAllocationHandle = allocation
                DispatchQueue.main.async {
                    self.toast = .success("Allocation Created Successfully")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if let allocationId = allocation?.id_ {
                        Utils.set(allocationId, for: .allocationID)
                    }
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    self.toast = .error("Error creating allocation")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.processing = false
                    }
                }
            }
        }
    }
    
    
    func setWalletInfo() {
        var error: NSError? = nil
        let wallet = Utils.get(key: .walletJSON) as? String
        ZcncoreSetWalletInfo(wallet, false,&error)
        if let error = error {
            print(error.localizedDescription)
        }
    }
    
    
    func onWalletCreateComplete(wallet: Wallet) {
        DispatchQueue.main.async {
            self.toast = .progress("Creating Allocation ...")
        }
        BoltViewModel().receiveFaucet()
        self.createAllocation()
    }
    
    func onWalletCreateFailed(error: String) {
        self.toast = .error(error)
    }
    
}

extension ZcncoreManager: ZcncoreWalletCallbackProtocol {
    func onWalletCreateComplete(_ status: Int, wallet: String?, err: String?) {
        DispatchQueue.main.async {
            guard status == ZcncoreStatusSuccess,
                  err == "",
                  let walletJSON = wallet,
                  let w = try? JSONDecoder().decode(Wallet.self, from: Data(walletJSON.utf8)) else {
                self.onWalletCreateFailed(error: err ?? "Something went wrong :(")
                return
            }
            
            print(w.debugDescription())
            Utils.set(walletJSON, for: .walletJSON)
            Utils.wallet = w
            Utils.getPublicEncryptionKey(mnemonic: w.mnemonics)
            self.setWalletInfo()
            try? self.initialiseSDK()
            self.onWalletCreateComplete(wallet: w)
        }
    }
}
