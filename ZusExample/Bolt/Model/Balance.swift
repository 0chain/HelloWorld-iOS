//
//  Balance.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 29/12/22.
//

import Foundation
import ZCNSwift
import Zcncore

extension ZCNSwift.Balance {
    var balanceToken: Double {
        get { return balance.tokens }
        set { self._balance = Int(exactly: ZcncoreConvertToValue(newValue).doubleValue) }
    }
    
    var usd: String {
        let usd: Double = Utils.zcnUsdRate
        let amount: Double = balanceToken * usd
        let dollarString: String = "$ \(amount.rounded(toPlaces: 3))"
        return dollarString
    }
}
