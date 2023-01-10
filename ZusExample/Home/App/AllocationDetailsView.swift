//
//  AllocationDetailsView.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 03/01/23.
//

import SwiftUI

struct AllocationDetailsView: View {
    let allocation: Allocation
    var body: some View {
        NavigationStack {
            List {
                Section("details") {
                    ListRow(title: "Allocation ID:", body: allocation.id)
                    ListRow(title: "Name:", body: allocation.name)
                    ListRow(title: "Expiration Date:", body: allocation.expirationDate?.formattedUNIX)
                    ListRow(title: "Size:", body: allocation.size?.formattedByteCount)
                    ListRow(title: "Used Size:", body: allocation.usedSize?.formattedByteCount)
                }
                
                Section("shards and challenges") {
                    ListRow(title: "Data Shards:", body: allocation.dataShards?.stringValue)
                    ListRow(title: "Parity Shards:", body: allocation.parityShards?.stringValue)
                    ListRow(title: "Number Of Writes:", body: allocation.id)
                    ListRow(title: "Number Of Reads:", body: allocation.id)
                    ListRow(title: "Number Of Failed challenges:", body: allocation.numFailedChallenges?.stringValue)
                    ListRow(title: "Latest Closed Challenge:", body: allocation.latestClosedChallenge)
                }
            } //list
            .navigationTitle(Text("Allocation Details"))
        } //NavigationStack
    }
    
    @ViewBuilder func ListRow(title: String, body: String?) -> some View {
        HStack {
            Text(title)
            Text(body ?? "")
        }//HStack
    }
}
