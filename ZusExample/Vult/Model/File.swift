//
//  File.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 02/01/23.
//

import Foundation

struct Directory: Codable {
    let list: [File]
}

typealias Files = [File]

struct File: Codable, Identifiable, Equatable  {
    
    var id: String {
        return status.rawValue + completedBytes.stringValue + name
    }
    
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
    
    var localThumbnailPath: URL {
      return Utils.downloadedThumbnailPath.appendingPathComponent(self.path)
    }
    
    var localUploadPath: URL {
      return Utils.uploadPath.appendingPathComponent(self.path)
    }
    
    var localFilePath: URL {
        return Utils.downloadPath.appendingPathComponent(self.path)
    }
    
    var isDownloaded: Bool {
      return FileManager.default.fileExists(atPath: localFilePath.path)
    }
    
     var isUploaded: Bool = true
    
     var completedBytes: Int = 0
    
    enum FileStatus: String {
        case error
        case progress
        case completed
    }
    
    var fileSize: String {
        switch status {
        case .completed: return size.formattedByteCount
        case .progress:
            let progress = Double(completedBytes) / Double(size) * 100
            let roundedProgress = String(format: "%.2f %%", progress)
            return roundedProgress
        case .error: return "failed"
        }
    }
    
    var fileDownloadPercent: String {
        return "\(completedBytes/size) %"
    }
    
     var status: FileStatus = .completed

}
