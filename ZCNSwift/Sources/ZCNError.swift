//
//  ZCNError.swift
//  ZCNSwift
//
//  Created by Aaryan Kothari on 27/04/23.
//

import Foundation

enum ZCNError: Error, LocalizedError, Equatable {
    case custom(String)
    
    public var errorDescription: String? {
        switch self {
        case .custom(let message): return NSLocalizedString(message, comment: "")
        }
    }
    
    var errorDomain: String {
        return "com.example.ZcnError"
    }
    
    var errorCode: Int {
        return 0
    }
    
    var localizedDescription: String {
        return errorDescription ?? NSLocalizedString("Unknown error.", comment: "")
    }
}
