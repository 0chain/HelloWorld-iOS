//
//  ZcncoreManager.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation
import Zcncore

final class ZcncoreManager: NSObject {
    
    static let shared = ZcncoreManager()
    private let network: NetworkConfig = NetworkConfig.bcv1
    
    func initialize(_ init: Bool = true,_ wallet: Bool = true) {
        do {
            try initialiseSDK()
            try setWalletInfo()
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
    
    func setWalletInfo(wallet: String? = nil) throws -> Bool {
        var error: NSError? = nil
        let wallet = wallet ?? Utils.get(key: .walletJSON) as? String
        ZcncoreSetWalletInfo(wallet, false,&error)
        if let error = error {
            throw error
        }
        
        return true
    }
    
}

