//
//  String.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 02/01/23.
//

import Foundation

extension String {
    var isValidAddress: Bool {
        return self.range(of: "([A-Fa-f0-9]{64})$", options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    var isValidNumber: Bool {
        return Double(self) != 0.0
    }
    
    var doubleValue: Double {
        return Double(self) ?? 0.0
    }
    
}
