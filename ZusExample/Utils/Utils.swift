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
    
    public static func getDocumentsPath() -> String {
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = allPaths[0]
        return documentsDirectory
    }
    
    public static func logPath() -> URL {
        let path = getDocumentsPath().appending(Utils.logFilePath)
        let url = URL(fileURLWithPath: path, isDirectory: false)
        return url
    }
    
}

extension Utils {
    
    enum UserDefaultsKey: String, CaseIterable {
        case wallet
        case walletJSON
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

