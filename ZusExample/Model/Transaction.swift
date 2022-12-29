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
    let hash, blockHash, version, clientID: String
    let toClientID, transactionData: String
    let value: Int64
    let signature: String
    let creationDate: Double
    let fee, transactionType: Int
    let transactionOutput, outputHash: String
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case createdAt = "CreatedAt"
        case updatedAt = "UpdatedAt"
        case hash = "Hash"
        case blockHash = "BlockHash"
        case version = "Version"
        case clientID = "ClientId"
        case toClientID = "ToClientId"
        case transactionData = "TransactionData"
        case value = "Value"
        case signature = "Signature"
        case creationDate = "CreationDate"
        case fee = "Fee"
        case transactionType = "TransactionType"
        case transactionOutput = "TransactionOutput"
        case outputHash = "OutputHash"
        case status = "Status"
    }
}
