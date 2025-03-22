//
//  TransactionsTable.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 25/06/23.
//

import SwiftUI
import ZCNSwift

struct TransactionsTable: View {
    var transactions: Transactions
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Text("Transaction Hash")
                Spacer()
                Text("Transaction Date").layoutPriority(1)
                Image(systemName: "chevron.right").opacity(0)
            }
            .font(.system(size: 16, weight: .bold, design: .default))
            
            ScrollView(showsIndicators: false) {
                ForEach(Array(transactions.sorted().enumerated()),id:\.offset) { index, txn in
                    TransactionRow(index: index, txn: txn)
                        .destination(destination: TransactionDetails(transaction: txn))
                }
            }
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
}

struct TransactionsTable_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsTable(transactions: [])
    }
}
