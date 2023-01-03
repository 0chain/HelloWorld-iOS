//
//  Utils.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation
import Zcncore

final class Utils: NSObject {
    private let scope : String = "0chain"
    private static let defaults = UserDefaults.standard
    private static let logFilePath = "/zcn.text"
    
    static var zcnUsdRate: Double {
        var error: NSError? = nil
        var usd: Double = 0.0
        ZcncoreGetZcnUSDInfo(&usd, &error)
        return usd
    }
}

extension Utils {
    enum FilePath: String, CaseIterable {
        case download
        case upload
        case thumbnail
    }
    
    enum DirectoryLocation {
      case Temporary
      case Document
      case Cache
    }
    
    public static func tempPath() -> String {
        return NSTemporaryDirectory() + "/0chain-\(Int.random(in: 899 ... 999999))/"
    }
    
    public static func getDocumentsPath() -> URL {
        let filemgr = FileManager.default
        return try! filemgr.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    
    public static func logPath() -> URL {
        return getDocumentsPath().appendingPathComponent(Utils.logFilePath)
    }
    
    public static func filePath(for name: String,_ type: FilePath) -> URL {
        let filemgr = FileManager.default
        let documentsDir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(type.rawValue)
        
        guard !filemgr.fileExists(atPath: documentsDir.path) else {
            return documentsDir
        }
        
        do {
            try filemgr.createDirectory(atPath: documentsDir.path, withIntermediateDirectories: true, attributes: nil)
            return documentsDir
        } catch {
            print(error.localizedDescription)
            return getDocumentsPath()
        }
    }
    
    public static var uploadPath : URL {
        return folderPath(type: FilePath.upload, dirType: .Temporary)
    }
    
    public static var downloadPath : URL {
      return folderPath(type: FilePath.download, dirType: .Document)
    }
    
    public static var downloadedThumbnailPath : URL {
      return folderPath(type: FilePath.thumbnail, dirType: .Document)
    }
    
    public static func folderPath(type: FilePath, dirType: DirectoryLocation) -> URL {
      //Create a media folder
      let filemgr = FileManager.default
        let documentsDir = getDocumentsPath(dirType: dirType).appendingPathComponent(type.rawValue)
      
      guard !filemgr.fileExists(atPath: documentsDir.path) else {
        return documentsDir
      }
      
      do{
        try filemgr.createDirectory(atPath: documentsDir.path,
                                    withIntermediateDirectories: true,
                                    attributes: nil)
        return documentsDir
      } catch {
        print(error.localizedDescription)
        //returns documents directory as default
        return getDocumentsPath(dirType: dirType)
      }
    }
    
    public static func getDocumentsPath(dirType: DirectoryLocation) -> URL {
      let filemgr = FileManager.default
      switch dirType {
      case .Temporary:
        //contents are deleted after 3 days in Temp directory
        return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)

      case .Document:
        return try! filemgr.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      case .Cache:
        return filemgr.urls(for: .cachesDirectory, in: .userDomainMask)[0]
      }
    }
}

extension Utils {
    
    enum UserDefaultsKey: String, CaseIterable {
        case wallet
        case walletJSON
        case balance
        case allocationID
    }
    
    public static func set(_ value: Any, for key: UserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    public static func get(key: UserDefaultsKey) -> Any {
        return defaults.value(forKey: key.rawValue)
    }
    
    public static var wallet: Wallet? {
        get {
            if let data = Utils.get(key: .wallet) as? Data,
               let wallet = try? JSONDecoder().decode(Wallet.self, from: data) {
                return wallet
            }
            return nil
        }
        
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                Utils.set(data, for: .wallet)
            }
        }
    }
    
}

