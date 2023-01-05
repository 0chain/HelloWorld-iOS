//
//  Wallet.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation

struct Wallet: Codable {
    let client_id: String
    var client_key: String
    var keys: [Keys]
    var mnemonics: String
    let version: String
    
    func debugDescription() -> String {
        return "\n----------Wallet----------\nclient_id: \(client_id)\nclient_key: \(client_key)\npublic_key: \(keys[0].public_key)\nprivate_key: \(keys[0].private_key)\nmnemonics: \(mnemonics)\nversion: \(version)\n--------------------------"
    }
}

struct Keys: Codable {
    let public_key: String
    let private_key: String
}
