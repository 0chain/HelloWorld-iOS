//
//  BoltViewModel.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation
import Combine
import SwiftUI
import ZCNSwift

class BoltViewModel:NSObject, ObservableObject {
    
    @Published var balance: Int = 0
    
    @Published var presentReceiveView: Bool = false
    @Published var presentErrorAlert: Bool = false
    @Published var presentSendView: Bool = false

    @Published var alertMessage: String = ""
    @Published var clientID: String = ""
    @Published var amount: String = ""

    @Published var transactions: ZCNSwift.Transactions = []
    
    @Published var presentPopup: Bool = false
    @Published var popup = ZCNToast.ZCNToastType.success("YES")
    
    let manager: TransactionManager = .init()
    @Published var userDefaultManager: UserdefaultManager = .init()
    
    var cancellable = Set<AnyCancellable>()
    
    override init() {
        super.init()
        Timer.publish(every: 30, on: RunLoop.main, in: .default)
            .autoconnect()
            .map { _ in }
            .sink(receiveValue: getBalance)
            .store(in: &cancellable)
        
        
        userDefaultManager.$balance
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .assign(to: &$balance)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.cancellable.removeAll()
    }
    
    func getBalance() {
        Task {
            do {
                let balance = try await self.manager.getBalance()
                DispatchQueue.main.async {
                    self.userDefaultManager.balance = balance
                }
            } catch {
                print("ERROR")
            }
        }
    }
    
    func walletAction(_ action: WalletActionType) {
        DispatchQueue.main.async {
            switch action {
            case .send:
                self.presentSendView = true
            case .receive:
                self.presentReceiveView = true
            case .faucet:
                self.receiveFaucet()
            }
        }
    }
    
    func receiveFaucet() {
        self.presentSendView = false
        Task {
            do {
                DispatchQueue.main.async {
                    self.popup = .progress("Recieving ZCN from faucet")
                    self.presentPopup = true
                }
                let txn = try await self.manager.faucet()
                self.transactions.append(txn)
                
                self.onTransactionComplete(t: txn)

            } catch let error {
                self.onTransactionFailed(error: error.localizedDescription)
            }
        }
    }
    
    func sendZCN() {
        DispatchQueue.main.async {
            self.presentSendView = false
        }
        Task {
            do {
                guard let amount = Double(self.amount) else {
                    self.onTransactionFailed(error: "invalid amount")
                    return
                }
                
                guard self.clientID.isValidAddress else {
                    self.onTransactionFailed(error: "invalid address")
                    return
                }
                
                guard !amount.isZero else {
                    self.onTransactionFailed(error: "amount cannot be zero")
                    return
                }
                
                guard amount <= self.balance.tokens else {
                    self.onTransactionFailed(error: "amount cannot be greater than balance")
                    return
                }
                
                guard Utils.wallet?.client_id != self.clientID else {
                    self.onTransactionFailed(error: "cannot send to own wallet")
                    return
                }
                
                DispatchQueue.main.async {
                    self.popup = .progress("Sending ZCN")
                    self.presentPopup = true
                }
                
                let txn = try await self.manager.send(toClientID: self.clientID, value: amount.value, desc: "")
                self.transactions.append(txn)

                self.onTransactionComplete(t: txn)

                DispatchQueue.main.async {
                    self.clientID = ""
                    self.amount = ""
                }
            } catch let error {
                self.onTransactionFailed(error: error.localizedDescription)
            }
        }
    }
    
    func copyClientID() {
        PasteBoard.general.setString(Utils.wallet?.client_key)
    }
    
    func getTransactions() {
        Task {
            do {
                let clientId = Utils.wallet?.client_id
                let txns1 = (try? await manager.getTransactions(toClient: clientId, fromClient: nil)) ?? []
                let txns2 = (try? await manager.getTransactions(toClient: nil, fromClient: clientId)) ?? []

                DispatchQueue.main.async {
                    self.transactions = txns1 + txns2
                }
                
            } catch {
                print("ERROR")
            }
        }
    }
    
    func onTransactionComplete(t: ZCNSwift.Transaction) {
        DispatchQueue.main.async {
            self.popup = .success("Success")
            self.presentPopup = true
            self.getBalance()
        }
    }
    
    func onTransactionFailed(error: String) {
        DispatchQueue.main.async {
            self.popup = .error(error)
            self.presentPopup = true
        }
    }
    
}
