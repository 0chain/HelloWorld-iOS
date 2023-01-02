//
//  Transaction.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 29/12/22.
//

import Foundation

typealias Transactions = [Transaction]

struct Transaction: Codable, Identifiable, Hashable {
    let id: Int
    let createdAt, updatedAt: String
    let deletedAt: String?
    let hash, blockHash: String
    let round: Int
    let version, clientID, toClientID, transactionData: String
    let value: Int
    let signature: String
    let creationDate: Double
    let fee, nonce, transactionType: Int
    let transactionOutput, outputHash: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case createdAt = "CreatedAt"
        case updatedAt = "UpdatedAt"
        case deletedAt = "DeletedAt"
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
