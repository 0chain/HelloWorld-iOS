//
//  NetworkConfig.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation

struct NetworkConfig: Codable {
    
    let signatureScheme: String
    let confirmationChainLength: Int
    let blockWorker, zboxURL: String
    
    enum CodingKeys: String, CodingKey {
        case signatureScheme = "signature_scheme"
        case confirmationChainLength = "confirmation_chain_length"
        case blockWorker = "block_worker"
        case zboxURL
    }
    
    /// Initialize core setup
    /// - Parameters:
    ///   - signatureScheme: signature Scheme of network setting
    ///   - confirmationChainLength: confirmationChainLength of network setting
    ///   - blockWorker: blockWorker of network setting
    ///   - zboxURL: zboxURL of network setting
    internal init(signatureScheme: String = "bls0chain",
                  confirmationChainLength: Int = 3,
                  blockWorker: String, zboxURL: String) {
        self.signatureScheme = signatureScheme
        self.confirmationChainLength = confirmationChainLength
        self.blockWorker = blockWorker
        self.zboxURL = zboxURL
    }
    
    static let demoZus = NetworkConfig(blockWorker: "https://demo.zus.network/dns", zboxURL: "https://0box.demo.zus.network")
    static let bcv1 = NetworkConfig(blockWorker: "https://bcv1.devnet-0chain.net/dns", zboxURL: "https://0box.bcv1.devnet-0chain.net")
    static let demo = NetworkConfig(blockWorker: "https://dev.0chain.net/dns", zboxURL: "https://0box.dev.0chain.net")
    static let potato = NetworkConfig(blockWorker: "https://potato.devnet-0chain.net/dns", zboxURL: "https://0box.potato.devnet-0chain.net")
    static let test = NetworkConfig(blockWorker: "https://test.0chain.net/dns", zboxURL: "https://0box.test.0chain.net")
    
    /// Host url of network
    var host: String {
        return URLComponents(string: blockWorker)?.host ?? ""
    }
    
}


