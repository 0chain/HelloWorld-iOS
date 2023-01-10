//
//  String.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 02/01/23.
//

import Foundation

extension String {
    
    /// isValidAddress - validate with regular expression and return Bool(true or false)
    var isValidAddress: Bool {
        return self.range(of: "([A-Fa-f0-9]{64})$", options: .regularExpression, range: nil, locale: nil) != nil
    }
    /// isValidNumber - validate string is number or not and return Bool(true or false)
    var isValidNumber: Bool {
        return Double(self) != 0.0
    }
    
    /// doubleValue - Convert String to Double and return Double value
    var doubleValue: Double {
        return Double(self) ?? 0.0
    }
    
    var json: [String:Any] {
        if let json = try? JSONSerialization.jsonObject(with: Data(self.utf8)) as? [String:Any] {
            return json
        } else {
            return [:]
        }
    }
}
