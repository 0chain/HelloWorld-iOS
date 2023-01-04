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
    var size: Int = 0
    
    var numBlocks : Int? = 0
    var actualSize : Int? = 0
    var actualNumBlocks : Int? = 0
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
    
    /// initialize of file allocation
    /// - Parameters:
    ///   - name: name of file
    ///   - mimetype: mimetype of file
    ///   - path: path of file
    ///   - lookupHash: lookup hash of file
    ///   - type: type of file
    ///   - size: size of file
    ///   - numBlocks: number of blocks
    ///   - actualSize: actual size of file
    ///   - actualNumBlocks: actual number of blocks
    ///   - encryptionKey: encryption key of file
    ///   - createdAt: createdAt of file
    ///   - updatedAt: updatedAt of file
    ///   - completedBytes: completed bytes of file
    internal init(name: String = "", mimetype: String = "", path: String = "", lookupHash: String = "", type: String = "", size: Int = 0, numBlocks: Int? = 0, actualSize: Int? = 0, actualNumBlocks: Int? = 0, encryptionKey: String? = "", createdAt: Double = 0, updatedAt: Double = 0, completedBytes: Int = 0) {
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
    
    /// Local thumbnail path and return with URL
    var localThumbnailPath: URL {
      return Utils.downloadedThumbnailPath.appendingPathComponent(self.path)
    }
    
    /// Local upload path and return with URL
    var localUploadPath: URL {
      return Utils.uploadPath.appendingPathComponent(self.path)
    }
    
    /// Local file path and return with URL
    var localFilePath: URL {
        return Utils.downloadPath.appendingPathComponent(self.path)
    }
    
    /// check local file path is exists or not and isdownload return Bool(True ot False)
    var isDownloaded: Bool {
      return FileManager.default.fileExists(atPath: localFilePath.path)
    }
    
    var completedBytes: Int = 0
    
    /// File status type
    enum FileStatus {
        case error
        case progress
        case completed
    }
    
    // file size base on file status
    var fileSize: String {
        switch status {
        case .completed: return size.formattedByteCount
        case .progress: return "\(completedBytes/size) %"
        case .error: return "failed"
        }
    }
    
    var status: FileStatus = .completed
}
