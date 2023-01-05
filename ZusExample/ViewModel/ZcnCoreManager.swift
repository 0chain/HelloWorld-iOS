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
    
    @Published var processing: Bool = false
    @Published var processTitle: String = "Create Wallet"
    
    func initialize() {
        do {
            try initialiseSDK()
            setWalletInfo()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Config network string
    /// - Returns: data of network
    class func configString() throws -> String? {
        let encoder: JSONEncoder = JSONEncoder()
        let data = try encoder.encode(self.network)
        return String(data: data, encoding: .utf8)
    }
    
    /// Initialize goSdk
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
    
    /// Create wallet of zcn
    func createWallet() {
        self.processTitle = "Creating Wallet"
        self.processing = true
        
        var error: NSError? = nil
        ZcncoreCreateWallet(self, &error)
        
        if let error = error {
            self.onWalletCreateFailed(error: error.localizedDescription)
        }
    }
    
    /// Create Allocation of zcn files
    func createAllocation() {
        DispatchQueue.global().async {
            do {
                let allocation = try ZcncoreManager.zboxStorageSDKHandle?.createAllocation("Allocation", datashards: 2, parityshards: 2, size: 214748364, expiration: Int64(Date().timeIntervalSince1970 + 2592000), lock: "10000000000")
               // VultViewModel.zboxAllocationHandle = allocation
                DispatchQueue.main.async {
                    self.processTitle = "Success"
                    self.processing = false
                }
                if let allocationId = allocation?.id_ {
                    Utils.set(allocationId, for: .allocationID)
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    /// Store wallet information
    func setWalletInfo() {
        var error: NSError? = nil
        let wallet = Utils.get(key: .walletJSON) as? String
        ZcncoreSetWalletInfo(wallet, false,&error)
        if let error = error {
            print(error.localizedDescription)
        }
    }
    
    
    /// Wallet create completed
    /// - Parameter wallet: wallet Information in Wallet object
    func onWalletCreateComplete(wallet: Wallet) {
        DispatchQueue.main.async {
            self.processTitle = "Creating Allocation"
        }
        BoltViewModel().receiveFaucet()
        self.createAllocation()
    }
    
    /// Wallet create failed
    /// - Parameter error: error of wallet create failed
    func onWalletCreateFailed(error: String) {
        
    }
    
}

extension ZcncoreManager: ZcncoreWalletCallbackProtocol {
    /// Wallet create completed
    /// - Parameters:
    ///   - status: status code of zcn wallet create
    ///   - wallet: wallet Information in wallet string
    ///   - err: error of wallet create
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
            try? self.initialiseSDK()
            self.onWalletCreateComplete(wallet: w)
        }
    }
}
