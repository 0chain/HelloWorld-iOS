//
//  BoltViewModel.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation
import Zcncore
import Combine
import UIKit

class BoltViewModel:NSObject, ObservableObject {
    
    @Published var balance: Double = 0.0
    @Published var balanceUSD: String = "$ 0.00"

    @Published var presentReceiveView: Bool = false
    @Published var presentErrorAlert: Bool = false
    @Published var presentSendView: Bool = false

    @Published var alertMessage: String = ""
    @Published var clientID: String = ""
    @Published var amount: String = ""

    @Published var transactions: Transactions = []
    
    var cancellable = Set<AnyCancellable>()
    
    override init() {
        super.init()
        Timer.publish(every: 30, on: RunLoop.main, in: .default)
            .autoconnect()
            .map { _ in }
            .sink(receiveValue: getBalance)
            .store(in: &cancellable)
        
        if let balance = Utils.get(key: .balance) as? Int {
            self.balance = balance.tokens
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.cancellable.removeAll()
    }
    /// getBalance - get zcn balance from gosdk api
    func getBalance() {
        var error: NSError? = nil
        ZcncoreGetBalance(self, &error)
        if let error = error { print(error.localizedDescription) }
    }
    
    /// Wallet action type
    /// - Parameter action: type of wallet action
    func walletAction(_ action: WalletActionType) {
        switch action {
        case .send:
            self.presentSendView = true
        case .receive:
            self.presentReceiveView = true
        case .faucet:
            self.receiveFaucet()
        }
    }
    
    /// Receive faucet from gosdk api
    func receiveFaucet() {
        self.presentSendView = false
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
    /// Send ZCN token
    func sendZCN() {
        DispatchQueue.global(qos: .default).async {
            do {
                var error: NSError? = nil
                let txObj =  ZcncoreNewTransaction(self,"0",0,&error)
                
                if let error = error { throw error }
                
                try txObj?.send(self.clientID, val: ZcncoreConvertToValue(Double(self.amount) ?? 0.0), desc: "")
                
                DispatchQueue.main.async {
                    self.clientID = ""
                    self.amount = ""
                }
            } catch let error {
                self.onTransactionFailed(error: error.localizedDescription)
            }
        }
    }
    /// Copy client Id
    func copyClientID() {
        UIPasteboard.general.string = Utils.wallet?.client_key ?? ""
    }
    
    /// Get transactions from gosdk api
    func getTransactions() {
        DispatchQueue.global().async {
            var error: NSError? = nil
            let clientId = Utils.wallet?.client_id
            
            ZcncoreGetTransactions(clientId, nil, nil, "desc", 20, 0, self , &error)
            ZcncoreGetTransactions(nil, clientId, nil, "desc", 20, 0, self , &error)
            
            if let error = error { print(error.localizedDescription) }
        }
    }
    
    /// Transaction completed
    /// - Parameter t: get Zcn core transaction information
    func onTransactionComplete(t: ZcncoreTransaction) {
    }
    
    /// Verify completed
    /// - Parameter t: get Zcn core transaction information
    func onVerifyComplete(t: ZcncoreTransaction) {
       
    }
    
    /// Transaction failed
    /// - Parameter error: error of transaction failed
    func onTransactionFailed(error: String) {
        DispatchQueue.main.async {
            self.alertMessage = error
            self.presentErrorAlert = true
        }
    }
    
}

extension BoltViewModel: ZcncoreGetBalanceCallbackProtocol {
    /// Balance Available
    /// - Parameters:
    ///   - status: status code of balance
    ///   - value: value of balance
    ///   - info: info of balance
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
    /// Auth completed
    /// - Parameters:
    ///   - t: get Zcn Core transaction information
    ///   - status: status code of success or failure
    func onAuthComplete(_ t: ZcncoreTransaction?, status: Int) { }
    
    /// Transaction completed
    /// - Parameters:
    ///   - t: get Zcn Core transaction information
    ///   - status: status code of success or failure
    func onTransactionComplete(_ t: ZcncoreTransaction?, status: Int) {
        
        DispatchQueue.main.async {
            let transaction = Transaction(hash: t?.getTransactionHash() ?? "", creationDate: Date().timeIntervalSince1970 * 1e9, status: status == 0 ? 1 : 2)
            self.transactions.append(transaction)
            self.objectWillChange.send()
        }
        
        guard status == ZcncoreStatusSuccess,
              let txObj = t else {
            self.onTransactionFailed(error: t?.getTransactionError() ?? "error: \(status)")
            return
        }
        try? txObj.verify()
        
        self.onTransactionComplete(t: txObj)
    }
    
    /// Verify Completed
    /// - Parameters:
    ///   - t: get Zcn core transaction information
    ///   - status: status code of success or failure
    func onVerifyComplete(_ t: ZcncoreTransaction?, status: Int) {
        self.getBalance()
    }
}

extension BoltViewModel: ZcncoreGetInfoCallbackProtocol {
    /// Information available of zcn
    /// - Parameters:
    ///   - op: transaction operation code
    ///   - status: status code of success or failure
    ///   - info: info of zcn core transaction
    ///   - err: error of zcn core transaction
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
                DispatchQueue.main.async {
                    self.transactions = Array(Set(transactions))
                }
            }
        } catch let error {
            print(error)
        }
    }
}
