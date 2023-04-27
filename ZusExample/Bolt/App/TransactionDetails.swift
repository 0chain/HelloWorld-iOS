//
//  TransactionDetails.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 07/01/23.
//

import SwiftUI
import ZCNSwift

struct TransactionDetails: View {
    var transaction: ZCNSwift.Transaction
    
    var body: some View {
        List {
            Section("Signatur and Hashes") {
                ListRow(title: "Transaction Hash:", value: transaction.hash)
                ListRow(title: "Block Hash:", value: transaction.blockHash)
                ListRow(title: "Output Hash:", value: transaction.outputHash)
                ListRow(title: "Client ID:", value: transaction.clientID)
                ListRow(title: "To Client ID:", value: transaction.toClientID)
                ListRow(title: "Signature:", value: transaction.signature)
            }
            
            Section("Amount Details") {
                ListRow(title: "Status:", value: transaction.status.stringValue)
                ListRow(title: "Value:", value: transaction.value?.stringValue)
                ListRow(title: "Fee:", value: transaction.fee?.stringValue)
                ListRow(title: "Date:", value: transaction.fomattedDate)
            }
            
            Section("Explorer") {
                Link(destination: URL(string: "https://staging-atlus-beta.testnet-0chain.net/transaction-details/\(transaction.hash)")!,label: { Text("View On Explorer").foregroundColor(.teal) })
            }
        }
            .navigationTitle(Text("Transaction Details"))
    }
    
    @ViewBuilder func DictionarySection(title:String,value: String?) -> some View {
        let dict = value?.json ?? [:]
        Section(title) {
            ForEach(Array(dict.keys).sorted(),id:\.self) { key in
                ListRow(title: key, value: String(describing: dict[key]))
            }
        }
    }
}

struct TransactionDetails_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetails(transaction: Transaction(createdAt: "", updatedAt: "", devaredAt: "", hash: "dgjydgjydgydgyjdgyddgjydgjydgydgyjdgyddgjydgjydgydgyjdgyd", blockHash: "duhdhdigdugdi", round: 2, version: "", clientID: "83738383763", toClientID: "397387387383", transactionData: "", value: 4, signature: "duhdujhdudh", creationDate: 2344, fee: 888, nonce: 88, transactionType: 2, transactionOutput: "djhdjhdj", outputHash: "djhdhidi", status: 2))
    }
}

struct ListRow: View {
    var title:String
    var value: String?
    @State var opened: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
            Text(value ?? "~")
                .lineLimit(10)
        }
        .onTapGesture {
            withAnimation {
                self.opened.toggle()
            }
        }
    }
}
