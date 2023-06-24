//
//  MultiUpload.swift
//  ZCNSwift
//
//  Created by Aaryan Kothari on 10/06/23.
//

import Foundation

public struct MultiUpload: Codable {
  public var fileName: String
  public var filePath: String
  public var thumbnailPath: String?
  public var remotePath: String
  public var encrypt: Bool
  
  public init(fileName: String, filePath: String, thumbnailPath: String?, remotePath: String, encrypt: Bool) {
    self.fileName = fileName
    self.filePath = filePath
    self.thumbnailPath = thumbnailPath
    self.remotePath = remotePath
    self.encrypt = encrypt
  }
}

public struct MultiDownload: Codable {
  public var localPath: String
  public var remotePath: String
  public var downloadOp: Int
  
  public init(localPath: String, remotePath: String,downloadOp: Int = 1) {
    self.localPath = localPath
    self.remotePath = remotePath
    self.downloadOp = downloadOp
  }
  
}
