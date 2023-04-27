//
//  TransactionManager.swift
//  ZCNSwift
//
//  Created by Aaryan Kothari on 27/04/23.
//

import Zcncore

public class TransactionManager {
    
    public init()  {
        
    }
    
    public func getBalance() async throws -> Int {
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
    
    public func faucet() async throws -> Transaction {
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

            do {
                try transaction.executeSmartContract("6dba10422e368813802877a85039d3985d96760ed844092319743fb3a76712d3", methodName: "pour", input: "{}", val: "10000000000")
            } catch {
                print("🧯 executeSmartContract error \(error.localizedDescription)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    public func send(toClientID: String?, value: Int, desc: String?) async throws -> Transaction {
        return try await withCheckedThrowingContinuation { continuation in
            let callback = ZcncoreTransactionCallback(onTransactionSuccess: { t in
                let transaction = Transaction(hash: t.getTransactionHash(), creationDate: Date().timeIntervalSince1970 * 1e9, status: 1)
                continuation.resume(returning: transaction)
            }, onTransactionFailed: { error in
                continuation.resume(throwing: ZCNError.custom(error))
            })
            
            var error: NSError?
            
            guard let transaction = ZcncoreNewTransaction(callback, "0", 0, &error) else {
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
    
    public func getTransactions(toClient: String?, fromClient: String?, block_hash: String? = nil, sort: String? = "desc", limit: Int = 20, offset: Int = 0) async throws -> Transactions {
        
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
    
    class ZcncoreTransactionCallback: NSObject, ZcncoreTransactionCallbackProtocol {
        
        var onAuth: (() -> Void)?
        var onverify: ((ZcncoreTransaction) -> Void)?
        var onverifyFailed: ((String) -> Void)?
        var onTransactionSuccess: ((ZcncoreTransaction) -> Void)?
        var onTransactionFailed: ((String) -> Void)?
        var amount: Int
        
        
        internal init(onAuth: (() -> Void)? = nil, onverify: ((ZcncoreTransaction) -> Void)? = nil, onTransactionSuccess:  ((ZcncoreTransaction) -> Void)? = nil, onTransactionFailed:  ((String) -> Void)? = nil, amount: Int = 0) {
            self.onAuth = onAuth
            self.onverify = onverify
            self.onTransactionSuccess = onTransactionSuccess
            self.onTransactionFailed = onTransactionFailed
            self.amount = amount
        }
        
        func onAuthComplete(_ t: ZcncoreTransaction?, status: Int) {
            self.onAuth?()
        }
        
        func onTransactionComplete(_ t: ZcncoreTransaction?, status: Int) {
            print("🌴 submitted \(t?.getTransactionHash() ?? "")")
            guard let transaction = t, status == ZcncoreStatusSuccess else {
                let errorMessage = t?.getTransactionError() ?? "An unknown error occured"
                print("🧯\(errorMessage)")
                self.onTransactionFailed?(errorMessage)
                return
            }
            
            do {
                try transaction.verify()
            } catch {
                print("🧯 failed to verify transaction: \(error.localizedDescription)")
            }
            
            self.onTransactionSuccess?(transaction)
        }
        
        func onVerifyComplete(_ t: ZcncoreTransaction?, status: Int) {
            print("🌴 verified \(t?.getVerifyOutput() ?? "")")
            guard let transaction = t, status == ZcncoreStatusSuccess else {
                let errorMessage = t?.getVerifyError() ?? "An unknown error occured"
                print("🧯\(errorMessage)")
                self.onverifyFailed?(errorMessage)
                return
            }
            self.onverify?(transaction)
        }
        
    }
    
    
    class ZcncoreGetInfoCallBack<T: Codable>: NSObject, ZcncoreGetInfoCallbackProtocol {
        
        var onSuccess: ((T) -> Void)?
        var onFailure: ((String) -> Void)?
        
        internal init(onSuccess: ((T) -> Void)? = nil, onFailure: ((String) -> Void)? = nil) {
            self.onSuccess = onSuccess
            self.onFailure = onFailure
        }
        
        func onInfoAvailable(_ op: Int, status: Int, info: String?, err: String?) {
            print("🌴 \(info ?? "INFO NOT FOUND")")
            guard status == ZcncoreStatusSuccess,
                  let response = info,
                  let data = response.data(using: .utf8,allowLossyConversion: true) else {
                print("🧯\(String(describing: T.self)) \(err ?? "Error")")
                self.onFailure?(err ?? "An unknown error occured")
                return
            }
            
            do {
                let object =  try JSONDecoder().decode(T.self, from: data)
                self.onSuccess?(object)
            } catch {
                print("🧯\(String(describing: T.self)) \(error)")
                self.onFailure?(error.localizedDescription)
            }
        }
    }

    class ZcncoreGetBalanceCallBack: NSObject, ZcncoreGetBalanceCallbackProtocol {
        
        var onBalance: ((Balance) -> Void)
        
        internal init(onBalance: @escaping ((Balance) -> Void)) {
            self.onBalance = onBalance
        }
        
        func onBalanceAvailable(_ status: Int, value: Int64, info: String?) {
            print("💰 \(info ?? "INFO NOT FOUND")")
            guard let response = info,
                  let data = response.data(using: .utf8),
                  let balance = try? JSONDecoder().decode(Balance.self, from: data)
            else {
                print("🧯 Failed to get balance")
                return
            }
            self.onBalance(balance)
        }
    }
}
