//
//  Int.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation
import Zcncore

extension Int {
    var stringValue: String {
        return String(self)
    }
    
    var tokens: Double {
        return ZcncoreConvertToToken(Int64(self))
    }
    
    var usd: Double {
        let usd: Double = Utils.zcnUsdRate
        let amount: Double = tokens * usd
        return amount
    }
}

extension String {
    var doubleValue: Double {
        return Double(self) ?? 0.0
    }
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Int64 {
    var tokens: Double {
        return ZcncoreConvertToToken(self)
    }
}
