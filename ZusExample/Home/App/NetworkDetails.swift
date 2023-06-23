//
//  NetworkDetails.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 09/01/23.
//

import SwiftUI
import ZCNSwift

struct NetworkDetails: View {
    @State var config : NetworkConfig = Network.devZus.config
    @State var network: Network = Network.devZus
    @State var changeNetwork: Network = Network.devZus
    @State var presentAlert: Bool = false

    init() {
        if let network = Utils.get(key: .network) as? String, let config = Network(rawValue: network) {
            self.config = config.config
            self.network = config
            self.changeNetwork = config
        }
    }
    
    var body: some View {
        NavigationView {
            
            List {
                Section("Details") {
                    ListRow(title: "Name: ", value: String(describing: network) + " Network")
                    ListRow(title: "Url: ",value: config.host)
                }
                
                Section {
                    Link(destination: URL(string: config.blockWorker)!) {
                        Text(config.blockWorker)
                    }
                }
            }
            .alert("Are you sure?", isPresented: $presentAlert) {
                Button {
                    
                } label: {
                    Text("No")
                }
                
                Button {
                    Utils.delete(key: .walletJSON)
                    Utils.delete(key: .allocationID)
                    Utils.set(changeNetwork.rawValue, for: .network)
                } label: {
                    Text("Yes, Change network")
                }
            } message: {
                Text("You will be logged out and will have to create a new wallet")
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
