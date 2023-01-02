//
//  VultViewModel.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation
import Zcncore
import Combine

class VultViewModel: NSObject, ObservableObject {
    static var zboxAllocationHandle : ZboxAllocation? = nil
    
    @Published var allocations: Allocations = []
    @Published var files: Files = []
    
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
    
    func uploadImage(fromPath: String, thumbnailPath: String, toPath: String) {
        do {
            try VultViewModel.zboxAllocationHandle?.uploadFile(withThumbnail: "",
                                                               localPath: "",
                                                               remotePath: "/",
                                                               fileAttrs: nil,
                                                               thumbnailpath: "",
                                                               statusCb: self)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func listDir(at path: String = "/") {
        do {
            guard let allocation = VultViewModel.zboxAllocationHandle else { return }
            
            var error: NSError? = nil
            let jsonStr = allocation.listDir(path, error: &error)
            
            if let error = error { throw error }
            
            guard let data = jsonStr.data(using: .utf8) else { return }
            
            let files = try JSONDecoder().decode(Directory.self, from: data).list

            DispatchQueue.main.async {
                self.files = files
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension VultViewModel: ZboxStatusCallbackMockedProtocol {
    func commitMetaCompleted(_ request: String?, response: String?, err: Error?) {
        
    }
    
    func completed(_ allocationId: String?, filePath: String?, filename: String?, mimetype: String?, size: Int, op: Int) {
        
    }
    
    func error(_ allocationID: String?, filePath: String?, op: Int, err: Error?) {
        
    }
    
    func inProgress(_ allocationId: String?, filePath: String?, op: Int, completedBytes: Int, data: Data?) {
        
    }
    
    func repairCompleted(_ filesRepaired: Int) {
        
    }
    
    func started(_ allocationId: String?, filePath: String?, op: Int, totalBytes: Int) {
        
    }
}
