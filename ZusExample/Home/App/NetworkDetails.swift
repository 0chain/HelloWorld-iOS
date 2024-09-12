//
//  NetworkDetails.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 09/01/23.
//

import SwiftUI
import ZCNSwift

struct NetworkDetails: View {
    @State private var network: Network

    init() {
        self.network = ZCNUserDefaults.network
    }
    
    var body: some View {
        NavigationView {
            
            List {
                Section("Details") {
                    ListRow(title: "Name: ", value: String(describing: network) + " Network")
                    ListRow(title: "Url: ",value: network.config.host)
                }
                
                Section {
                    Link(destination: URL(string: network.config.blockWorker)!) {
                        Text(network.config.blockWorker)
                    }
                }
            }
            .navigationTitle(Text("Network Details"))
        }
    }
}

struct NetworkDetails_Previews: PreviewProvider {
    static var previews: some View {
        NetworkDetails()
    }
}
