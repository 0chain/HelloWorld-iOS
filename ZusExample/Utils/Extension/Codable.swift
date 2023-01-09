//
//  Codable.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 07/01/23.
//

import Foundation

extension Encodable {
    /// Encode into JSON and return `Data`
    func jsonData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
}
