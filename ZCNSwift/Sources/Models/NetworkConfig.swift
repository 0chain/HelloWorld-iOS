//
//  NetworkConfig.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation

public struct NetworkConfig: Codable {
    
    public let signatureScheme: String
    public let confirmationChainLength: Int
    public let blockWorker, zboxURL: String
    
    enum CodingKeys: String, CodingKey {
        case signatureScheme = "signature_scheme"
        case confirmationChainLength = "confirmation_chain_length"
        case blockWorker = "block_worker"
        case zboxURL
    }
    
    internal init(signatureScheme: String = "bls0chain",
                  confirmationChainLength: Int = 3,
                  blockWorker: String, zboxURL: String) {
        self.signatureScheme = signatureScheme
        self.confirmationChainLength = confirmationChainLength
        self.blockWorker = blockWorker
        self.zboxURL = zboxURL
    }
    
    internal init(scheme: String) {
        let blockWorker = "https://" + scheme + "/dns"
        let zboxURL = "https://0box." + scheme
        self.init(blockWorker: blockWorker, zboxURL: zboxURL)
    }
    
    public var host: String {
        return URLComponents(string: blockWorker)?.host ?? ""
    }
    
}

public enum Network: String,CaseIterable {
    case demoZus = "demo.zus.network"
    case devZus = "dev.zus.network"
    case bcv1 = "bcv1.devnet-0chain.net"
    case demo = "demo.0chain.net"
    case potato = "potato.devnet-0chain.net"
    case test = "test.0chain.net"
    
    public var config: NetworkConfig {
        return NetworkConfig(scheme: self.rawValue)
    }
}

