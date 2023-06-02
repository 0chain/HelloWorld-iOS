//
//  UploadManager.swift
//  ZCNSwift
//
//  Created by Aaryan Kothari on 27/04/23.
//

import Zcncore

public class ZCNFileManager {
    
    static let shared = ZCNFileManager()
    
    private static var allocationID = ""
    
    private init() { }
    
    public static func setAllocationID(id: String) {
        ZCNFileManager.allocationID = id
    }
    
    public static func listDir(remotePath: String) async throws -> Directory {
      return try await withUnsafeThrowingContinuation { continuation in
        DispatchQueue.global(qos: .userInitiated).async {
          var error: NSError?
          let jsonStr = ZboxListDir(allocationID, remotePath, &error)
          
          print("\(remotePath)📚: \(jsonStr)")
          
          if let error = error {
            continuation.resume(throwing: error)
          } else {
            guard let data = jsonStr.data(using: .utf8) else {
                continuation.resume(throwing: ZCNError.custom("json parsing error"))
              return
            }
            
            do {
              let result = try JSONDecoder().decode(Directory.self, from: data)
              continuation.resume(returning: result)
            } catch {
              continuation.resume(throwing: error)
            }
          }
        }
      }
    }
    
    public static func multiUploadFiles(workdir: String, localPaths: [String],thumbnails: [String], names: [String], remotePath: String,statusCb: ZboxStatusCallbackMockedProtocol? = nil) throws {
      var error: NSError?
      DispatchQueue.global(qos: .userInitiated).async {
        let path = localPaths.joined(separator: " ")
        let thumbnail = thumbnails.joined(separator: " ")
        let remote = remotePath.appending("/").replacingOccurrences(of: "//", with: "/")
        let name = names.joined(separator: " ")
        let encrypt = Array(repeating: "0", count: names.count).joined()
        ZboxMultiUpload(allocationID, workdir, path, name, encrypt, thumbnail, remote, statusCb, &error)
      }
      if let error = error {
        throw error
      }
    }
}
