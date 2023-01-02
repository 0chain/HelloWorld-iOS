//
//  VultViewModel.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation
import Zcncore
import Combine

class VultViewModel: NSObject {
    static var zboxAllocationHandle : ZboxAllocation? = nil
    
    func createAllocation() {
        DispatchQueue.global().async {
            do {
                let allocation = try ZcncoreManager.zboxStorageSDKHandle?.createAllocation("", datashards: 2, parityshards: 2, size: 2147483648, expiration: Int64(Date().timeIntervalSince1970 + 2592000), lock: "10000000000")
                VultViewModel.zboxAllocationHandle = allocation
                Utils.set(allocation?.id_, for: .allocationID)
            } catch let error {
                print(error)
            }
        }
    }
    
}
