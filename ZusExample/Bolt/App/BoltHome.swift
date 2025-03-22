//
//  BoltHome.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 29/12/22.
//

import SwiftUI
import ZCNSwift

struct BoltHome: View {
    @ObservedObject var boltVM: BoltViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            AvailableBalanceBlock()
            
            WalletActionStack(walletAction: boltVM.walletAction(_:))
            
            TransactionsTable(transactions: boltVM.transactions)
            
            NavigationLink(destination: SendForm(sendZCN: boltVM.sendZCN), isActive: $boltVM.presentSendView) {
                EmptyView()
            }
        }
        .toast(presented: $boltVM.presentPopup, type: boltVM.popup)
        .padding(20)
        .navigationTitle(Text("Bolt"))
        .navigationBarTitleDisplayMode(.large)
        .task{ await boltVM.getTransactions() }
        .alert("Recieve ZCN", isPresented: $boltVM.presentReceiveView,actions: {recievAlert}) {
            Text("Wallet address\n\(ZCNUserDefaults.wallet?.client_id ?? "")")
        }
    }
    
    @ViewBuilder var recievAlert: some View {
        Button("Copy",action:boltVM.copyClientID)
    }
    
}

struct BoltHome_Previews: PreviewProvider {
    static var boltVM: BoltViewModel = {
        let boltVM = BoltViewModel()
        boltVM.transactions = [Transaction(hash: "dhudhiduididg", creationDate: 93778937837837, status: 1),Transaction(hash: "dhudheijeioeiduididg", creationDate: 937789337837, status: 1),Transaction(hash: "dhudhidehieeuididg", creationDate: 9377893474837, status: 2)]
        return boltVM
    }()
    static var previews: some View {
        NavigationView {
            BoltHome(boltVM: boltVM)
        }
    }
}
