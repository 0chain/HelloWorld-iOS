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
    
    public static func getAllocation() async throws -> Allocation {
        return try await withUnsafeThrowingContinuation { continuation in
            DispatchQueue.global().async {
                let decoder = JSONDecoder()
                                
                var error: NSError?
                
                let jsonStr = SdkGetAllocations(&error)

                if let data = jsonStr.data(using: .utf8), let allocations = try? JSONDecoder().decode([Allocation].self, from: data), let allocation = allocations.first {
                    continuation.resume(returning: allocation)
                } else {
                    continuation.resume(throwing: error ?? ZCNError.custom("failed to get allocation details"))
                }
            }
        }
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
    
    public static func multiUploadFiles(workdir: String, options: [MultiUpload],statusCb: ZboxStatusCallbackMockedProtocol? = nil) throws {
        var error: NSError?
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.withoutEscapingSlashes]
        let data = try encoder.encode(options)
        let string = String(data: data, encoding: .utf8)
        
        ZboxMultiUpload(allocationID, workdir, string, statusCb, &error)
        if let error = error {
            throw error
        }
    }
    
    public static func downloadFile(remotePath: String, localPath: String, statusCb: ZboxStatusCallbackMockedProtocol? = nil) throws {
      var error: NSError?
      ZboxDownloadFile(allocationID, remotePath, localPath, statusCb, &error)
      
      if let error = error {
        throw error
      }
    }
    
    public static func getAuthTicket(file: File) throws -> String {
        var error: NSError?
        let ticket = ZboxGetAuthToken(allocationID, file.path, file.name, "f", "", "", 0, 0, &error)
        return ticket
    }
    
}
