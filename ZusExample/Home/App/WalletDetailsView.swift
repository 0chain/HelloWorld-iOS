//
//  WalletDetailsView.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 07/01/23.
//

import SwiftUI

struct WalletDetailsView: View {
    let wallet: Wallet?
    @AppStorage(Utils.UserDefaultsKey.publicEncKey.rawValue) var publicEncKey: String = ""
    @AppStorage(Utils.UserDefaultsKey.walletJSON.rawValue) var walletJSON: String = ""
    
    var prettyJSON: String? {
        if let jsonData = walletJSON.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                if let prettyPrintedJsonString = String(data: prettyJsonData, encoding: .utf8) {
                    return prettyPrintedJsonString
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                return nil
            }
        }
        return nil
    }
    
    init() {
        self.wallet = Utils.wallet
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("details") {
                    ListRow(title: "Client ID", body: wallet?.client_id)
                    ListRow(title: "Private Key", body: wallet?.keys.first?.private_key ?? "")
                    ListRow(title: "Public Key", body: wallet?.keys.first?.public_key ?? "")
                    ListRow(title: "Mnemonics", body: wallet?.mnemonics)
                    ListRow(title: "Public Encryption Key", body: publicEncKey)
                }
                
                Section("json") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(prettyJSON ?? "")
                            .copyableText(prettyJSON ?? "")
                    }
                }
            }
            .navigationTitle(Text("Wallet Details"))
        }
    }
    
    @ViewBuilder func ListRow(title: String, body: String?) -> some View {
        HStack {
            NavigationLink(title) {
                Text(body ?? "~")
                    .padding(30)
                    .multilineTextAlignment(.center)
                    .copyableText(body ?? "")
            }
        }
        .multilineTextAlignment(.leading)
       
    }
}


struct WalletDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WalletDetailsView()
    }
}
