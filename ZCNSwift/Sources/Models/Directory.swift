//
//  File.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 02/01/23.
//

import Foundation

public struct Directory: Codable {
    public let list: [File]
}

public typealias Files = [File]

public struct File: Codable, Identifiable, Equatable  {
    
    public var id: String {
        return status.rawValue + completedBytes.stringValue + name
    }
    
    public var name : String = ""
    public var mimetype: String = ""
    public var path: String = ""
    public var lookupHash: String = ""
    public var type: String = ""
    public var size: Int = 0
    
    public var numBlocks : Int? = 0
    public var actualSize : Int? = 0
    public var actualNumBlocks : Int? = 0
    public var encryptionKey: String? = ""
    public var createdAt: Double = 0
    public var updatedAt: Double = 0
    
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
    
    public init(name: String = "", mimetype: String = "", path: String = "", lookupHash: String = "", type: String = "", size: Int = 0, numBlocks: Int? = 0, actualSize: Int? = 0, actualNumBlocks: Int? = 0, encryptionKey: String? = "", createdAt: Double = 0, updatedAt: Double = 0, completedBytes: Int = 0) {
        self.name = name
        self.mimetype = mimetype
        self.path = path
        self.lookupHash = lookupHash
        self.type = type
        self.size = size
        self.numBlocks = numBlocks
        self.actualSize = actualSize
        self.actualNumBlocks = actualNumBlocks
        self.encryptionKey = encryptionKey
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.completedBytes = completedBytes
    }
    

    
    public enum FileStatus: String {
        case error
        case progress
        case completed
    }
    
    public var completedBytes: Int = 0

    public var status: FileStatus = .completed

    public var isUploaded: Bool = true
}
