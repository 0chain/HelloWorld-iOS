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
    
    public static func getZcnUSDInfo() -> Double {
        var error: NSError? = nil
        var usd: Double = 0.0
        ZcncoreGetZcnUSDInfo(&usd, &error)
        return usd
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
    
    public static func getBalance() async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            let callback = ZcncoreGetBalanceCallBack { balance in
                continuation.resume(returning: balance.balance)
            }
            
            var error: NSError?
            ZcncoreGetBalance(callback, &error)
            
            if let error = error {
                print("🧯 balance error: \(error.localizedDescription)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    public static func faucet() async throws -> Transaction {
        return try await withCheckedThrowingContinuation { continuation in
            let callback = ZcncoreTransactionCallback(onTransactionSuccess: { t in
                let transaction = Transaction(hash: t.getTransactionHash(), creationDate: Date().timeIntervalSince1970 * 1e9, status: 1)
                continuation.resume(returning: transaction)
            }, onTransactionFailed: { error in
                continuation.resume(throwing: ZCNError.custom(error))
            }, amount: 10000000000)
            
            var error: NSError?
            
            guard let transaction = ZcncoreNewTransaction(callback, "0", 0, &error) else {
                continuation.resume(throwing: error!)
                return
            }
            DispatchQueue.global().async {
                do {
                    try transaction.executeSmartContract("6dba10422e368813802877a85039d3985d96760ed844092319743fb3a76712d3", methodName: "pour", input: "{}", val: "10000000000")
                } catch {
                    print("🧯 executeSmartContract error \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func send(toClientID: String?, value: Int, desc: String?) async throws -> Transaction {
        return try await withCheckedThrowingContinuation { continuation in
            let callback = ZcncoreTransactionCallback(onTransactionSuccess: { t in
                let transaction = Transaction(hash: t.getTransactionHash(), creationDate: Date().timeIntervalSince1970 * 1e9, status: 1)
                continuation.resume(returning: transaction)
            }, onTransactionFailed: { error in
                continuation.resume(throwing: ZCNError.custom(error))
            })
            
            var error: NSError?
            
            guard let transaction = ZcncoreNewTransaction(callback, "1000000", 0, &error) else {
                continuation.resume(throwing: error!)
                return
            }
            
            do {
                try transaction.send(toClientID, val: String(value), desc: desc)
            } catch {
                print("🧯 send error \(error.localizedDescription)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    public static func getTransactions(toClient: String?, fromClient: String?, block_hash: String? = nil, sort: String? = "desc", limit: Int = 20, offset: Int = 0) async throws -> Transactions {
        
        return try await withCheckedThrowingContinuation { continuation in
            let callback = ZcncoreGetInfoCallBack { (transactions: Transactions) in
                continuation.resume(returning: transactions)
            } onFailure: { error in
                continuation.resume(throwing: ZCNError.custom(error))
            }
            
            var error: NSError?
            
            ZcncoreGetTransactions(toClient, fromClient, block_hash, sort, limit, offset, callback, &error)
            
            if let error = error {
                continuation.resume(throwing: ZCNError.custom(error.localizedDescription))
            }
        }
    }
    
}
