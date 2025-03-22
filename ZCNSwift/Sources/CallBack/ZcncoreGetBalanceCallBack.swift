//
//  ZcncoreGetBalanceCallBack.swift
//  ZCNSwift
//
//  Created by Aaryan Kothari on 23/06/23.
//

import Zcncore

class ZcncoreGetBalanceCallBack: NSObject, ZcncoreGetBalanceCallbackProtocol {
    
    var onBalance: ((Balance) -> Void)
    
    internal init(onBalance: @escaping ((Balance) -> Void)) {
        self.onBalance = onBalance
    }
    
    func onBalanceAvailable(_ status: Int, value: Int64, info: String?) {
        print("💰 \(info ?? "INFO NOT FOUND")")
        guard let response = info,
              let data = response.data(using: .utf8),
              let balance = try? JSONDecoder().decode(Balance.self, from: data)
        else {
            print("🧯 Failed to get balance")
            return
        }
        self.onBalance(balance)
    }
}
