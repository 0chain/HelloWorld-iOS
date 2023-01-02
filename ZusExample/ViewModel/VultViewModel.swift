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
    
    @Published var allocations: Allocations = []
    
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
    
    func getAllocations()  {
        DispatchQueue.global().async {
            do {
                let decoder = JSONDecoder()
                var error: NSError? = nil
                
                guard let zboxStorageSDKHandle = ZcncoreManager.zboxStorageSDKHandle else { return }
                
                let allocations = zboxStorageSDKHandle.getAllocations(&error)
                if let error = error { throw error }
                
                let allocationData = Data(allocations.utf8)
                let allocationsList = try decoder.decode(Allocations.self, from: allocationData)
                
                for i in 0..<allocationsList.count {
                    var allocation = allocationsList[i]
                    let allocationStats = zboxStorageSDKHandle.getAllocationStats(allocation.id, error: &error)
                    if let error = error { throw error }
                    
                    let allocationStatsData = Data(allocationStats.utf8)
                    let allocationStatsModel = try decoder.decode(Allocation.self, from: allocationStatsData)
                    
                    allocation.addStats(allocationStatsModel)
                }
                DispatchQueue.main.async {
                    self.allocations = allocationsList
                }
            } catch let error {
                print(error)
            }
        }
    }
    
}
