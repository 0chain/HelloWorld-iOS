//
//  BoltHome.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 29/12/22.
//

import SwiftUI

struct BoltHome: View {
    @StateObject var boltVM: BoltViewModel = BoltViewModel()
    
    var body: some View {
        GeometryReader { gr in
            VStack(alignment: .leading) {
                
                AvailableBalanceBlock()
                
                WalletActionStack(width: gr.size.width)
                
                Text("transactions").bold()
                    .padding(.bottom,-7)
                ScrollView(showsIndicators: false) {
                    ForEach(Array(boltVM.transactions.sorted().enumerated()),id:\.offset) { index, txn in
                        Link(destination: URL(string: "https://staging-atlus-beta.testnet-0chain.net/transaction-details/\(txn.hash)")!,label: { TransactionRow(index: index, txn: txn) })
                    }
                    .listStyle(.plain)
                }
            }
        }
        .padding(20)
        .environmentObject(boltVM)
        .onAppear(perform: boltVM.getTransactions)
        .alert("Recieve ZCN", isPresented: $boltVM.presentReceiveView,actions: {recievAlert}) {
            Text("Use your client ID to recieve zcn to your wallet - \(Utils.wallet?.client_id ?? "")")
        }
        .alert("Send ZCN", isPresented: $boltVM.presentSendView,actions: {sendAlert})
    }
    
    @ViewBuilder func TransactionRow(index:Int,txn:Transaction) -> some View {
        HStack(spacing: 15) {
            Text("\(index+1). \(txn.hash)")
            Spacer()
            Text(Date(timeIntervalSince1970: txn.creationDate/1e9).formatted()).layoutPriority(1)
            Image(systemName: "chevron.right")
        }
        .foregroundColor(txn.status == 1 ? .black : .pink)
        .lineLimit(1)
        .padding(.vertical,10)
    }
    
    @ViewBuilder var sendAlert: some View {
        
        TextField("client ID", text: $boltVM.clientID)
        TextField("amount", text: $boltVM.amount)
            .keyboardType(.decimalPad)
        
        Button("Send",action:boltVM.sendZCN)
            .disabled(!boltVM.clientID.isValidAddress || !boltVM.amount.isValidNumber)
    }
    
    @ViewBuilder var recievAlert: some View {
        Button("OK") {
            
        }
        Button("Copy") {
            UIPasteboard.general.string = Utils.wallet?.client_id ?? ""
        }
    }
    
    
    
}

struct BoltHome_Previews: PreviewProvider {
    static var previews: some View {
        BoltHome()
    }
}
