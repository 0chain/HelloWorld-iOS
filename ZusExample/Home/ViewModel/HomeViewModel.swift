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
    
    /// Present allocation of details view
    func presentAllocationDetails() {
        self.pushAllocationDetails = true
    }
    
    /// Present wallet of detail view
    func presentWalletDetails() {
        self.pushWalletDetails = true
    }
    
    /// Present network of detail view
    func presentNetworkDetails() {
        self.pushNetworkDetails = true
    }
}
