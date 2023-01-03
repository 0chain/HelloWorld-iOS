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

    private static let network: NetworkConfig = NetworkConfig.demoZus
    static var zboxStorageSDKHandle : SdkStorageSDK? = nil
    @Published var vultButtonTitle: String = "Create Allocation"
    
    func initialize() {
        do {
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
        var error: NSError? = nil
        ZcncoreCreateWallet(self, &error)
        
        if let error = error {
            self.onWalletCreateFailed(error: error.localizedDescription)
        }
    }
    
    func createAllocation() {
        self.vultButtonTitle = "Creating Allocation ..."
        DispatchQueue.global().async {
            do {
                BoltViewModel().receiveFaucet()
                let allocation = try ZcncoreManager.zboxStorageSDKHandle?.createAllocation("Allocation", datashards: 2, parityshards: 2, size: 2147483648, expiration: Int64(Date().timeIntervalSince1970 + 2592000), lock: "10000000000")
                VultViewModel.zboxAllocationHandle = allocation
                if let allocationId = allocation?.id_ {
                    Utils.set(allocationId, for: .allocationID)
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    self.vultButtonTitle = "Allocation Creation Failed"
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
        
    }
    
    func onWalletCreateFailed(error: String) {
        
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
            
            self.setWalletInfo()
            
            self.onWalletCreateComplete(wallet: w)
        }
    }
}
