//
//  Balance.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 29/12/22.
//

import Foundation
import Zcncore

struct Balance: Codable, Equatable {
    private var txn: String?
    private var round: Int64?
    private var _balance: Int64?
    private var error: String?
    
    enum CodingKeys: String, CodingKey {
        case txn
        case round
        case _balance = "balance"
        case error
    }
    
    var balance: Int64 {
        return _balance ?? 0
    }
    
    var balanceToken: Double {
        get { return ZcncoreConvertToToken(balance) }
        set { self._balance = Int64(exactly: ZcncoreConvertToValue(newValue).doubleValue) }
    }
    
    var usd: String {
        let usd: Double = Utils.zcnUsdRate
        let amount: Double = balanceToken * usd
        let dollarString: String = "$ \(amount.rounded(toPlaces: 3))"
        return dollarString
    }
    
}
