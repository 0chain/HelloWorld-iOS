//
//  ZCNSwift.swift
//  ZCNSwift
//
//  Created by Aaryan Kothari on 23/06/23.
//

import Foundation

public enum ZCNSwiftState {
    case walletNotFound
    case allocationNotFound
    case walletAndAllocationExists
    case error(String)
}

public func initialize() -> ZCNSwiftState {
    do {
        try ZcncoreManager.initialiseSDK(wallet: ZCNUserDefaults.wallet, network: ZCNUserDefaults.network)

        guard let wallet = ZCNUserDefaults.wallet else {
            return .walletNotFound
        }
        
        try ZcncoreManager.setWalletInfo(wallet: wallet)
        
        guard let allocationId = ZCNUserDefaults.allocationID else {
            return .allocationNotFound
        }
        
        ZboxManager.setAllocationID(id: allocationId)
        
        let usd = ZcncoreManager.getZcnUSDInfo()
        ZCNUserDefaults.usd = usd
        
        return .walletAndAllocationExists
    } catch let error {
        print(error.localizedDescription)
        return .error(error.localizedDescription)
    }
}
