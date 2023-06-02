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
    
}
