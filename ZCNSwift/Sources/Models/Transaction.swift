//
//  Transaction.swift
//  ZCNSwift
//
//  Created by Aaryan Kothari on 27/04/23.
//

import Foundation

public typealias Transactions = [Transaction]

public struct Transaction: Codable, Identifiable, Hashable,Comparable {
    public static func < (lhs: Transaction, rhs: Transaction) -> Bool {
        return rhs.creationDate < lhs.creationDate
    }
    
    public init(id: Int? = nil, createdAt: String? = nil, updatedAt: String? = nil, devaredAt: String? = nil, hash: String, blockHash: String = "", round: Int? = nil, version: String? = nil, clientID: String? = nil, toClientID: String? = nil, transactionData: String? = nil, value: Int? = nil, signature: String? = nil, creationDate: Double, fee: Int? = nil, nonce: Int? = nil, transactionType: Int? = nil, transactionOutput: String? = nil, outputHash: String? = nil, status: Int) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.devaredAt = devaredAt
        self.hash = hash
        self.blockHash = blockHash
        self.round = round
        self.version = version
        self.clientID = clientID
        self.toClientID = toClientID
        self.transactionData = transactionData
        self.value = value
        self.signature = signature
        self.creationDate = creationDate
        self.fee = fee
        self.nonce = nonce
        self.transactionType = transactionType
        self.transactionOutput = transactionOutput
        self.outputHash = outputHash
        self.status = status
    }
    
    public var id: Int?
    public var createdAt, updatedAt: String?
    public var devaredAt: String?
    public var hash, blockHash: String
    public var round: Int?
    public var version, clientID, toClientID, transactionData: String?
    public var value: Int?
    public var signature: String?
    public var creationDate: Double
    public var fee, nonce, transactionType: Int?
    public var transactionOutput, outputHash: String?
    public var status: Int

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case createdAt = "CreatedAt"
        case updatedAt = "UpdatedAt"
        case devaredAt = "DevaredAt"
        case hash
        case blockHash = "block_hash"
        case round, version
        case clientID = "client_id"
        case toClientID = "to_client_id"
        case transactionData = "transaction_data"
        case value, signature
        case creationDate = "creation_date"
        case fee, nonce
        case transactionType = "transaction_type"
        case transactionOutput = "transaction_output"
        case outputHash = "output_hash"
        case status
    }
    
    public var fomattedDate: String {
        return Date(timeIntervalSince1970: self.creationDate/1e9).formatted()
    }
}
