//
//  BoltHome.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 29/12/22.
//

import SwiftUI
import ZCNSwift

struct BoltHome: View {
    @EnvironmentObject var boltVM: BoltViewModel

    var body: some View {
        GeometryReader { gr in
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    
                    AvailableBalanceBlock()
                    
                    WalletActionStack(width: gr.size.width)
                    
                    HStack(spacing: 15) {
                        Text("Transaction Hash")
                        Spacer()
                        Text("Transaction Date").layoutPriority(1)
                        Image(systemName: "chevron.right").opacity(0)
                    }
                    .font(.system(size: 16, weight: .bold, design: .default))
                    //.bold()
                    ScrollView(showsIndicators: false) {
                        ForEach(Array(boltVM.transactions.sorted().enumerated()),id:\.offset) { index, txn in
                            NavigationLink(destination: TransactionDetails(transaction: txn)) {
                                TransactionRow(index: index, txn: txn)
                            }
                        }
                        .listStyle(.plain)
                    }
                }
                if boltVM.presentPopup {
                    ZCNToast(type: boltVM.popup,presented: $boltVM.presentPopup)
                }
                
                NavigationLink(destination: SendForm().environmentObject(boltVM), isActive: $boltVM.presentSendView) {
                    EmptyView()
                }
            }
        }
        .padding(20)
        .environmentObject(boltVM)
        .navigationTitle(Text("Bolt"))
        .navigationBarTitleDisplayMode(.large)
        .onAppear(perform: boltVM.getTransactions)
        .alert("Recieve ZCN", isPresented: $boltVM.presentReceiveView,actions: {recievAlert}) {
            Text("Wallet address\n\(ZCNUserDefaults.wallet?.client_id ?? "")")
        }
      //  .alert("Send ZCN", isPresented: $boltVM.presentSendView,actions: {sendAlert})
        .alert("Error", isPresented: $boltVM.presentErrorAlert) {
            Text(boltVM.alertMessage)
        }
    }
    
    @ViewBuilder func TransactionRow(index:Int,txn: ZCNSwift.Transaction) -> some View {
        HStack(spacing: 15) {
            Text("\(index+1). \(txn.hash)")
            Spacer()
            Text(Date(timeIntervalSince1970: txn.creationDate/1e9).formatted(date: .omitted, time: .shortened)).layoutPriority(1)
            Image(systemName: "chevron.right")
        }
        .copyableText(txn.hash)
        .foregroundColor(txn.status == 1 ? .primary : .pink)
        .lineLimit(1)
        .padding(.vertical,10)
    }
    
    @ViewBuilder var sendAlert: some View {
        
        TextField("client ID", text: $boltVM.clientID)
        TextField("amount", text: $boltVM.amount)
        
        Button("Send",action:boltVM.sendZCN)
        //.disabled(!boltVM.clientID.isValidAddress || !boltVM.amount.isValidNumber)
    }

    
    @ViewBuilder var recievAlert: some View {
        Button("Copy",action:boltVM.copyClientID)
    }
    
}

struct BoltHome_Previews: PreviewProvider {
    static var previews: some View {
        var boltVM: BoltViewModel = {
            let boltVM = BoltViewModel()
            boltVM.transactions = [Transaction(hash: "dhudhiduididg", creationDate: 93778937837837, status: 1),Transaction(hash: "dhudheijeioeiduididg", creationDate: 937789337837, status: 1),Transaction(hash: "dhudhidehieeuididg", creationDate: 9377893474837, status: 2)]
            return boltVM
        }()
        NavigationView {
            BoltHome()
                .environmentObject(boltVM)
        }
    }
}
