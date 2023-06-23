//
//  Balance.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 29/12/22.
//

import Foundation
import Zcncore

public struct Balance: Codable, Equatable {
    
    private var txn: String?
    private var round: Int?
    public var _balance: Int?
    private var error: String?
    
    internal init(txn: String? = nil, round: Int? = nil,balance _balance: Int? = nil, error: String? = nil) {
        self.txn = txn
        self.round = round
        self._balance = _balance
        self.error = error
    }
    
    enum CodingKeys: String, CodingKey {
        case txn
        case round
        case _balance = "balance"
        case error
    }
    
    public var balance: Int {
        return _balance ?? 0
    }
    
}
