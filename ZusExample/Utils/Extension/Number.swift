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
    
    var formattedByteCount: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        formatter.isAdaptive = true
        return formatter.string(fromByteCount: Int64(self))
    }
    
    var formattedUNIX: String {
        return Date(timeIntervalSince1970: Double(self)).formatted()
    }
}

extension Double {
    /// rounds a double  number
    /// - Parameter places: number of places to round number
    /// - Returns: rounded number in double
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
