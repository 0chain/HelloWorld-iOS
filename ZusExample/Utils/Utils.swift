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
    
    /// zcnUsdRate - Convert ZCN to USD and return Double value
    static var zcnUsdRate: Double {
        var error: NSError? = nil
        var usd: Double = 0.0
        ZcncoreGetZcnUSDInfo(&usd, &error)
        return usd
    }
}

extension Utils {
    /// FilePath - file path options
    enum FilePath: String, CaseIterable {
        case download
        case upload
        case thumbnail
    }
    
    /// DirectoryLocation - directory location options
    enum DirectoryLocation {
      case Temporary
      case Document
      case Cache
    }
    
    /// tempPath - This function return temporary path
    public static func tempPath() -> String {
        return NSTemporaryDirectory() + "/0chain-\(Int.random(in: 899 ... 999999))/"
    }
    
    /// getDocumentsPath - This function return documents path
    public static func getDocumentsPath() -> URL {
        let filemgr = FileManager.default
        return try! filemgr.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    
    /// logPath - This function return documents path as a URL
    public static func logPath() -> URL {
        return getDocumentsPath().appendingPathComponent(Utils.logFilePath)
    }
    
    /// File path
    /// - Parameters:
    ///   - name: name of file 
    ///   - type: type of FilePath
    /// - Returns:document path in URL
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
    
    /// uploadPath - Return upload file path in URL
    public static var uploadPath : URL {
        return folderPath(type: FilePath.upload, dirType: .Temporary)
    }
    
    // downloadPath - Return download file path in URL
    public static var downloadPath : URL {
      return folderPath(type: FilePath.download, dirType: .Document)
    }
    
    // downloadPath - Return download thumbnail file path in URL
    public static var downloadedThumbnailPath : URL {
      return folderPath(type: FilePath.thumbnail, dirType: .Document)
    }
    
    /// Folder Path
    /// - Parameters:
    ///   - type: type of FilePath
    ///   - dirType: Directory type of DirectoryLocation
    /// - Returns: document path in URL
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
    
    /// Get document path
    /// - Parameter dirType: Directory type of DirectoryLocation
    /// - Returns: document path in URL
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
    /// UserDefaultsKey - UserDefaults key options
    enum UserDefaultsKey: String, CaseIterable {
        case wallet
        case walletJSON
        case balance
        case allocationID
    }
    
    /// Store value in user defaults
    /// - Parameters:
    ///   - value: Value of object which store on user default
    ///   - key: key of UserDefaultsKey
    public static func set(_ value: Any, for key: UserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    /// Get value from user default
    /// - Parameter key: key of UserDefaultsKey
    /// - Returns: value of user default key
    public static func get(key: UserDefaultsKey) -> Any {
        return defaults.value(forKey: key.rawValue)
    }
    
    /// wallet - return wallet type
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

