//
//  HomeViewModel.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 07/01/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var pushAllocationDetails: Bool = false
    @Published var pushWalletDetails: Bool = false
    @Published var pushNetworkDetails: Bool = false

    func presentAllocationDetails() {
        self.pushAllocationDetails = true
    }
    
    func presentWalletDetails() {
        self.pushWalletDetails = true
    }
    
    func presentNetworkDetails() {
        self.pushNetworkDetails = true
    }
}
