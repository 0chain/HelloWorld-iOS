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
    private let network: NetworkConfig = NetworkConfig.demoZus
    
    func initialize() {
        do {
            try initialiseSDK()
            setWalletInfo()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func configString() throws -> String? {
        let encoder: JSONEncoder = JSONEncoder()
        let data = try encoder.encode(self.network)
        return String(data: data, encoding: .utf8)
    }
    
    func initialiseSDK() throws {
        var error: NSError? = nil
        let logPath = Utils.logPath()
        ZcncoreSetLogFile(logPath.path, true)
        
        let jsonData = try JSONEncoder().encode(self.network)
        let configString = String(data: jsonData, encoding: .utf8)!
        let wallet = Utils.get(key: .walletJSON) as? String
        
        ZcncoreInit(configString, &error)
        
        SdkInitStorageSDK(wallet, configString, &error)
        
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

