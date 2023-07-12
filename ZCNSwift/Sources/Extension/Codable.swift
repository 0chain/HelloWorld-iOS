//
//  Codable.swift
//  ZCNSwift
//
//  Created by Aaryan Kothari on 04/06/23.
//

import Foundation

extension Encodable {
    func json() throws -> String {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        let string = String(data: data, encoding: .utf8)
        return string ?? ""
    }
}
