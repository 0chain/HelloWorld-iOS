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
    var zboxAllocationHandle : ZboxAllocation? = nil
    
    func createAllocation() {
        DispatchQueue.global().async {
            var error: NSError?
            
            do {
                
                if let error = error { throw error }
                
                guard let wallet = Utils.wallet else { return }
                
                let request = ZcncoreCreateAllocationRequest()
                request.dataShards = 2
                request.parityShards = 2
                request.size = 2147483648
                request.expiration = Int64(Date().timeIntervalSince1970 + 2592000)
                request.owner = wallet.client_id
                request.ownerPublicKey = wallet.client_key
                request.readPriceMin = 0
                request.readPriceMax = 184467440737095516
                request.writePriceMin = 0
                request.writePriceMax = 184467440737095516
                
                let blobbers = ZboxGetBlobbers(&error)
                
                self.zboxAllocationHandle = try ZcncoreManager.zboxStorageSDKHandle?.createAllocation(withBlobbers: "alloc", datashards: 2, parityshards: 2, size: 2147483648, expiration: Int64(Date().timeIntervalSince1970 + 2592000), lock: "10000000000", blobberUrls: "", blobberIds: "")
                
            } catch let error {
                print(error)
            }
        }
    }
    
}
