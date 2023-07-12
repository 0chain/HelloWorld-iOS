//
//  ZcncoreGetInfoCallBack.swift
//  ZCNSwift
//
//  Created by Aaryan Kothari on 23/06/23.
//

import Zcncore

class ZcncoreGetInfoCallBack<T: Codable>: NSObject, ZcncoreGetInfoCallbackProtocol {
    
    var onSuccess: ((T) -> Void)?
    var onFailure: ((String) -> Void)?
    
    internal init(onSuccess: ((T) -> Void)? = nil, onFailure: ((String) -> Void)? = nil) {
        self.onSuccess = onSuccess
        self.onFailure = onFailure
    }
    
    func onInfoAvailable(_ op: Int, status: Int, info: String?, err: String?) {
        print("🌴 \(info ?? "INFO NOT FOUND")")
        guard status == ZcncoreStatusSuccess,
              let response = info,
              let data = response.data(using: .utf8,allowLossyConversion: true) else {
            print("🧯\(String(describing: T.self)) \(err ?? "Error")")
            self.onFailure?(err ?? "An unknown error occured")
            return
        }
        
        do {
            let object =  try JSONDecoder().decode(T.self, from: data)
            self.onSuccess?(object)
        } catch {
            print("🧯\(String(describing: T.self)) \(error)")
            self.onFailure?(error.localizedDescription)
        }
    }
}
