//
//  Int.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation

extension Int {
    var stringValue: String {
        return String(self)
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
