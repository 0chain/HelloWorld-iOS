//
//  ZcncoreManager.swift
//  ZCNSwift
//
//  Created by Aaryan Kothari on 04/06/23.
//

import Foundation
import Zcncore

public class ZcncoreManager {
    
    static var zboxStorageSDKHandle : SdkStorageSDK? = nil

    public static func initialiseSDK(wallet: Wallet?, network: Network) throws {
        var error: NSError? = nil
        
        //let logPath = Utils.logPath()
        //ZcncoreSetLogFile(logPath.path, true)
        
        let config = try network.config.json()
        
        ZcncoreInit(config, &error)
        
        if let walletJSON = try wallet?.json() {
            zboxStorageSDKHandle = SdkInitStorageSDK(walletJSON, config, &error)
        }
        
        if let error = error {
            throw error
        }
    }
    
    public static func createWallet() throws -> Wallet {
        
        var error: NSError?
        let walletJson = ZcncoreCreateWalletOffline(&error)
        print("📒 \(walletJson)")
        
        if let error = error {
            throw ZCNError.custom(error.localizedDescription)
        }
        
        let wallet = try JSONDecoder().decode(Wallet.self, from: Data(walletJson.utf8))
        
        return wallet
    }
    
    public static func createAllocation() throws -> String {
        guard let sdk = zboxStorageSDKHandle else {
            throw ZCNError.custom("unknown error occured!")
        }
        let allocation = try sdk.createAllocation(2, parityshards: 2, size: 214748364, expiration: Int64(Date().timeIntervalSince1970 + 2630000), lock: "4500000000")
        
        return allocation.id_
    }
    
    public static func getPublicEncryptionKey(wallet: Wallet) throws -> String {
        var error: NSError?
        let key = ZcncoreGetPublicEncryptionKey(wallet.mnemonics, &error)
        
        if let error = error {
            throw ZCNError.custom(error.localizedDescription)
        }
        
        return key
    }
    
    public static func setWalletInfo(wallet: Wallet?) throws {
        guard let wallet = wallet else { return }
        var error: NSError? = nil
        let data = try JSONEncoder().encode(wallet)
        let json = String(data: data, encoding: .utf8)
        ZcncoreSetWalletInfo(json, false,&error)
        if let error = error {
            throw ZCNError.custom(error.localizedDescription)
        }
    }
    
    
}
