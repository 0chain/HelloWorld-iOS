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

    @Published var presentReceiveView: Bool = false
    @Published var presentSendView: Bool = false

    @Published var transactions: Transactions = []
    
    var cancellable = Set<AnyCancellable>()
    
    override init() {
        super.init()
        Timer.publish(every: 30, on: RunLoop.main, in: .default)
            .autoconnect()
            .map { _ in }
            .sink(receiveValue: getBalance)
            .store(in: &cancellable)
        
        if let balance = Utils.get(key: .balance) as? Int64 {
            self.balance = balance.tokens
        }
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
        switch action {
        case .send:
            self.sendZCN(to: "6dba10422e368813802877a85039d3985d96760ed844092319743fb3a76712d3", amount: 5000000)
            self.presentSendView = true
        case .receive:
            VultViewModel().createAllocation()
            self.presentReceiveView = true
        case .faucet:
            self.receiveFaucet()
        }
    }
    
    func receiveFaucet() {
        DispatchQueue.global().async {
            var error: NSError?
            
            do {
                
                let txObj =  ZcncoreNewTransaction(self,"0",0,&error)
                
                if let error = error { throw error }

                try txObj?.executeSmartContract("6dba10422e368813802877a85039d3985d96760ed844092319743fb3a76712d3",
                                               methodName: "pour",
                                               input: "{}",
                                               val: "10000000000")
            } catch let error {
                self.onTransactionFailed(error: error.localizedDescription)
            }
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
        DispatchQueue.global().async {
            var error: NSError? = nil
            let clientId = Utils.wallet?.client_id
            
            ZcncoreGetTransactions(clientId, nil, nil, "desc", 20, 0, self , &error)
            ZcncoreGetTransactions(nil, clientId, nil, "desc", 20, 0, self , &error)
            
            if let error = error { print(error.localizedDescription) }
        }
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
        Utils.set(value, for: .balance)
        DispatchQueue.main.async {
            self.balance = balance.balanceToken
            self.balanceUSD = balance.usd
        }
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
        try? txObj.verify()
        self.onTransactionComplete(t: txObj)
    }
    
    func onVerifyComplete(_ t: ZcncoreTransaction?, status: Int) {
        self.getBalance()
    }
}

extension BoltViewModel: ZcncoreGetInfoCallbackProtocol {
    func onInfoAvailable(_ op: Int, status: Int, info: String?, err: String?) {
        guard status == ZcncoreStatusSuccess,
              let response = info,
              let data = response.data(using: .utf8,allowLossyConversion: true) else {
            print(err ?? "onInfoAvailable Error")
            return
        }
        
        do {
            if op == ZcncoreOpStorageSCGetTransactions {
                let txns = try JSONDecoder().decode(Transactions.self, from: data)
                var transactions = self.transactions
                transactions.append(contentsOf: txns)
                self.transactions = Array(Set(transactions))
            }
        } catch let error {
            print(error)
        }
    }
}
