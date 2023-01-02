//
//  File.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 02/01/23.
//

import Foundation

class Directory: NSObject, Codable {
    let list: [File]
}

typealias Files = [File]

class File: NSObject, Codable, Identifiable {
    
    var name : String = ""
    var mimetype: String = ""
    var path: String = ""
    var lookupHash: String = ""
    var type: String = ""
    var size: Int64 = 0
    
    var numBlocks : Int64? = 0
    var actualSize : Int64? = 0
    var actualNumBlocks : Int64? = 0
    var encryptionKey: String? = ""
    var createdAt: Double = 0
    var updatedAt: Double = 0
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case mimetype = "mimetype"
        case path = "path"
        case lookupHash = "lookup_hash"
        case type = "type"
        case size = "size"
        case  numBlocks = "num_blocks"
        case  encryptionKey = "encryption_key"
        case  actualSize = "actual_size"
        case  actualNumBlocks = "actual_num_blocks"
        case  createdAt = "created_at"
        case  updatedAt = "updated_at"
    }
}
