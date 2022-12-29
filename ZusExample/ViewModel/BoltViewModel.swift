//
//  BoltViewModel.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation
import Zcncore
import Combine

class BoltViewModel:NSObject, ObservableObject {
    
    @Published var balance: Double = 0.0
    @Published var balanceUSD: String = "$ 0.00"

    var cancellable = Set<AnyCancellable>()
    
    override init() {
        super.init()
        Timer.publish(every: 30, on: RunLoop.main, in: .default)
            .autoconnect()
            .map { _ in }
            .sink(receiveValue: getBalance)
            .store(in: &cancellable)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.cancellable.removeAll()
    }
    
    func getBalance() {
        var error: NSError? = nil
        ZcncoreGetBalance(self, &error)
        if let error = error { print(error.localizedDescription) }
    }
    
    func walletAction(_ action: WalletActionType) {
        
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
    
    func onTransactionComplete(t: ZcncoreTransaction) {
        
    }
    
    func onVerifyComplete(t: ZcncoreTransaction) {
       
    }
    
    func onTransactionFailed(error: String) {
       
    }
    
}

extension BoltViewModel: ZcncoreGetBalanceCallbackProtocol {
    func onBalanceAvailable(_ status: Int, value: Int64, info: String?) {
        guard let response = info,
              let data = response.data(using: .utf8),
              let balance = try? JSONDecoder().decode(Balance.self, from: data) else {
                  return
              }
        
        self.balance = balance.balanceToken.rounded(toPlaces: 3)
        self.balanceUSD = balance.usd
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
