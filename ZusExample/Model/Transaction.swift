//
//  Transaction.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 29/12/22.
//

import Foundation

typealias Transactions = [Transaction]

struct Transaction: Codable, Identifiable, Hashable,Comparable {
    static func < (lhs: Transaction, rhs: Transaction) -> Bool {
        return rhs.creationDate < lhs.creationDate
    }
    
    internal init(id: Int? = nil, createdAt: String? = nil, updatedAt: String? = nil, devaredAt: String? = nil, hash: String, blockHash: String = "", round: Int? = nil, version: String? = nil, clientID: String? = nil, toClientID: String? = nil, transactionData: String? = nil, value: Int? = nil, signature: String? = nil, creationDate: Double, fee: Int? = nil, nonce: Int? = nil, transactionType: Int? = nil, transactionOutput: String? = nil, outputHash: String? = nil, status: Int) {
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
    
    var id: Int?
    var createdAt, updatedAt: String?
    var devaredAt: String?
    var hash, blockHash: String
    var round: Int?
    var version, clientID, toClientID, transactionData: String?
    var value: Int?
    var signature: String?
    var creationDate: Double
    var fee, nonce, transactionType: Int?
    var transactionOutput, outputHash: String?
    var status: Int

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
    
}
