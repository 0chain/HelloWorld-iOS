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

class ZcncoreManager: ObservableObject {
    
    private static var network: NetworkConfig = Network.devZus.config
    
    @Published var processing: Bool = false
    @Published var toast: ZCNToast.ZCNToastType = .progress("Creating Wallet...")

    func initialize() {
        do {
            if let networkScheme = Utils.get(key: .network) as? String, let network = Network(rawValue: networkScheme) {
                ZcncoreManager.network = network.config
            }
            try ZCNSwift.ZcncoreManager.initialiseSDK(wallet: Utils.wallet, network: .devZus)
            try ZCNSwift.ZcncoreManager.setWalletInfo(wallet: Utils.wallet)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func createWallet() {
        
        do {
            self.toast = .progress("Creating Wallet ...")
            self.processing = true
            
            let wallet = try ZCNSwift.ZcncoreManager.createWallet()
            
            Utils.set(try wallet.jsonString(), for: .walletJSON)
            Utils.wallet = wallet
            
            let getPublicEncryptionKey = try ZCNSwift.ZcncoreManager.getPublicEncryptionKey(wallet: wallet)
            Utils.set(getPublicEncryptionKey, for: Utils.UserDefaultsKey.publicEncKey)

            
            try ZCNSwift.ZcncoreManager.setWalletInfo(wallet: wallet)
            try ZCNSwift.ZcncoreManager.initialiseSDK(wallet: wallet, network: Network.devZus)
            
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
                    Utils.set(allocationId, for: .allocationID)
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
