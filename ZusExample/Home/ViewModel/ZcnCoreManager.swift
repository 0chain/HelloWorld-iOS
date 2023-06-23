//
//  ZcncoreManager.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation
import Zcncore
import Photos
import ZCNSwift

class ZusExampleViewModel: ObservableObject {
    
    private static var network: NetworkConfig = Network.devZus.config
    
    @Published var processing: Bool = false
    @Published var toast: ZCNToast.ZCNToastType = .progress("Creating Wallet...")

    init() {
        self.initialize()
    }
    
    func initialize() {
        do {
            ZusExampleViewModel.network = ZCNUserDefaults.network.config
            try ZCNSwift.ZcncoreManager.initialiseSDK(wallet: ZCNUserDefaults.wallet, network: .devZus)
            try ZCNSwift.ZcncoreManager.setWalletInfo(wallet: ZCNUserDefaults.wallet)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func createWallet() {
        
        do {
            self.toast = .progress("Creating Wallet ...")
            self.processing = true
            
            let wallet = try ZCNSwift.ZcncoreManager.createWallet()
            
            ZCNUserDefaults.wallet = wallet
            ZCNUserDefaults.walletJSON = try wallet.jsonString()
            
            let getPublicEncryptionKey = try ZCNSwift.ZcncoreManager.getPublicEncryptionKey(wallet: wallet)
            ZCNUserDefaults.publicEncKey = getPublicEncryptionKey
            
            try ZCNSwift.ZcncoreManager.setWalletInfo(wallet: wallet)
            try ZCNSwift.ZcncoreManager.initialiseSDK(wallet: wallet, network: ZCNSwift.Network.devZus)
            
            DispatchQueue.main.async {
                self.toast = .progress("Creating Allocation ...")
            }
            BoltViewModel().receiveFaucet()
            self.createAllocation()


        } catch {
            self.toast = .error(error.localizedDescription)
        }
    }
    
    func createAllocation() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            do {
                let allocationId = try ZCNSwift.ZcncoreManager.createAllocation()
                DispatchQueue.main.async {
                    self.toast = .success("Allocation Created Successfully")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    ZCNUserDefaults.allocationID = allocationId
                    self.requestPhotoAuth()
                    
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.toast = .error("Error creating allocation")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.processing = false
                    }
                }
            }
        }
    }
    
    func requestPhotoAuth() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in }
    }
    
}
