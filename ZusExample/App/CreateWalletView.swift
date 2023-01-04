//
//  ContentView.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import SwiftUI

struct CreateWalletView: View {
    @ObservedObject var zcncoreVM: ZcncoreManager
    
    var body: some View {
        VStack {
            Button("Create Wallet", action: zcncoreVM.createWallet)
        } //VStack
        .padding()
    }
}

struct CreateWalletView_Previews: PreviewProvider {
    static var previews: some View {
        CreateWalletView(zcncoreVM: .shared)
    }
}
