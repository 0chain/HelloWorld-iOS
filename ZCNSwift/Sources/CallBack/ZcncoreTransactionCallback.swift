//
//  ZcncoreTransactionCallback.swift
//  ZCNSwift
//
//  Created by Aaryan Kothari on 23/06/23.
//

import Zcncore

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
