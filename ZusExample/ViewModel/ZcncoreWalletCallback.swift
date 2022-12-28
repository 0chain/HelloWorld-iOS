//
//  ZcncoreWalletCallback.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation
import Zcncore

class ZcncoreWalletCallback:NSObject {
    
    func createWallet() {
        var error: NSError? = nil
        ZcncoreCreateWallet(self, &error)
        
        if let error = error {
            self.onWalletCreateFailed(error: error.localizedDescription)
        }
    }
    
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
    
    func onWalletCreateComplete(wallet: Wallet) {
        fatalError("Must Override")
    }
    
    func onWalletCreateFailed(error: String) {
        fatalError("Must Override")
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

extension ZcncoreWalletCallback: ZcncoreWalletCallbackProtocol {
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
            Utils.set(walletJSON, for: .walletJSON)
            
            if (try? ZcncoreManager.shared.setWalletInfo(wallet: walletJSON)) ?? false {
                self.onWalletCreateFailed(error: "setWalletInfo failed")
            }
            
            self.onWalletCreateComplete(wallet: w)
        }
    }
}

extension ZcncoreWalletCallback: ZcncoreTransactionCallbackProtocol {
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

extension ZcncoreWalletCallback: ZcncoreGetInfoCallbackProtocol {
    func onInfoAvailable(_ op: Int, status: Int, info: String?, err: String?) {
        
    }
}
