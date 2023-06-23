//
//  Walllet.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 04/06/23.
//

import Foundation

public struct Wallet: Codable {
    public let client_id: String
    public var client_key: String
    public var keys: [Keys]
    public var mnemonics: String
    public let version: String
    
    public init(client_id: String, client_key: String, keys: [Keys], mnemonics: String, version: String) {
        self.client_id = client_id
        self.client_key = client_key
        self.keys = keys
        self.mnemonics = mnemonics
        self.version = version
    }
}

public struct Keys: Codable {
    public let public_key: String
    public let private_key: String
    
    public init(public_key: String, private_key: String) {
        self.public_key = public_key
        self.private_key = private_key
    }
}
