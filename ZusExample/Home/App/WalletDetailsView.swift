//
//  WalletDetailsView.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 07/01/23.
//

import SwiftUI

struct WalletDetailsView: View {
    let wallet: Wallet?
    
    init() {
        self.wallet = Utils.wallet
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("details") {
                    ListRow(title: "Client ID:", body: wallet?.client_id)
                    ListRow(title: "Private Key:", body: wallet?.keys.first?.private_key ?? "")
                    ListRow(title: "Public Key:", body: wallet?.keys.first?.public_key ?? "")
                    ListRow(title: "Mnemonics:", body: wallet?.mnemonics)
                }
            }
            .navigationTitle(Text("Wallet Details"))
        }
    }
    
    @ViewBuilder func ListRow(title: String, body: String?) -> some View {
        HStack {
            Text(title)
            Text(body ?? "~")
        }
    }
}


struct WalletDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WalletDetailsView()
    }
}
