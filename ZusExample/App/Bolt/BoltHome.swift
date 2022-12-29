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
                
                Image("bolt")
                    .resizable()
                    .scaledToFit()
                    .frame(width: gr.size.width/6)
                    .aspectRatio(2, contentMode: .fit)
                
                AvailableBalanceBlock()
                
                WalletActionStack(width: gr.size.width)
                
                List(boltVM.transactions) { txn in
                    Text(txn.hash)
                }
                
            }
        }
        .padding(20)
        .environmentObject(boltVM)
        .onAppear(perform: boltVM.getTransactions)
    }
    
}

struct BoltHome_Previews: PreviewProvider {
    static var previews: some View {
        BoltHome()
    }
}
