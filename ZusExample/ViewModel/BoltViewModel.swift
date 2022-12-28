//
//  BoltViewModel.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation
import Zcncore

class BoltViewModel:NSObject, ObservableObject {
    
    func sendZCN(to clientID: String, amount:Int) {
        DispatchQueue.global(qos: .default).async {
            do {
                var error: NSError? = nil
                let txObj =  ZcncoreNewTransaction(self,"0",0,&error)
                
                if let error = error { throw error }
                
                try txObj?.send(clientID, val: amount.stringValue, desc: "")
                
            } catch let error {
                self.onTransactionFailed(error: error.localizedDescription)
            }
        }
    }
    
    func getTransactions() {
        var error: NSError? = nil
        let clientId = Utils.wallet?.client_id
        
        ZcncoreGetTransactions(clientId, nil, nil, "desc", 20, 0, self , &error)
        ZcncoreGetTransactions(nil, clientId, nil, "desc", 20, 0, self , &error)
        
        if let error = error { print(error.localizedDescription) }
        
    }
    
    func onTransactionComplete(t: ZcncoreTransaction) {
        fatalError("Must Override")
    }
    
    func onVerifyComplete(t: ZcncoreTransaction) {
        fatalError("Must Override")
    }
    
    func onTransactionFailed(error: String) {
        fatalError("Must Override")
    }
    
}

extension BoltViewModel: ZcncoreTransactionCallbackProtocol {
    func onAuthComplete(_ t: ZcncoreTransaction?, status: Int) { }
    
    func onTransactionComplete(_ t: ZcncoreTransaction?, status: Int) {
        
        guard status == ZcncoreStatusSuccess,
              let txObj = t else {
            self.onTransactionFailed(error: t?.getTransactionError() ?? "error: \(status)")
            return
        }
        
        self.onTransactionComplete(t: txObj)
    }
    
    func onVerifyComplete(_ t: ZcncoreTransaction?, status: Int) {
        
    }
}

extension BoltViewModel: ZcncoreGetInfoCallbackProtocol {
    func onInfoAvailable(_ op: Int, status: Int, info: String?, err: String?) {
        
    }
}
