//
//  ZCNDefaults.swift
//  ZCNSwift
//
//  Created by Aaryan Kothari on 23/06/23.
//

import Foundation

public enum ZCNUserDefaultsKey: String, CaseIterable {
    case wallet
    case walletJSON
    case balance
    case allocationID
    case network
    case publicEncKey
    case usd
}

public struct ZCNUserDefaults {
    private static let defaults = UserDefaults.standard

    public static var wallet: Wallet? {
        get {
            if let data = get(key: .wallet) as? Data,
               let wallet = try? JSONDecoder().decode(Wallet.self, from: data) {
                return wallet
            }
            return nil
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                set(data, for: .wallet)
            }
        }
    }

    public static var walletJSON: String? {
        get { return defaults.string(forKey: ZCNUserDefaultsKey.walletJSON.rawValue) }
        set { defaults.set(newValue, forKey: ZCNUserDefaultsKey.walletJSON.rawValue) }
    }

    public static var balance: Int {
        get { return defaults.integer(forKey: ZCNUserDefaultsKey.balance.rawValue) }
        set { defaults.set(newValue, forKey: ZCNUserDefaultsKey.balance.rawValue) }
    }

    public static var allocationID: String? {
        get { return defaults.string(forKey: ZCNUserDefaultsKey.allocationID.rawValue) }
        set { defaults.set(newValue, forKey: ZCNUserDefaultsKey.allocationID.rawValue) }
    }

    public static var network: Network {
        get { return Network(rawValue: defaults.string(forKey: ZCNUserDefaultsKey.network.rawValue) ?? "") ?? .devZus }
        set { defaults.set(newValue.rawValue, forKey: ZCNUserDefaultsKey.network.rawValue) }
    }

    public static var publicEncKey: String? {
        get { return defaults.string(forKey: ZCNUserDefaultsKey.publicEncKey.rawValue) }
        set { defaults.set(newValue, forKey: ZCNUserDefaultsKey.publicEncKey.rawValue) }
    }

    public static var usd: String? {
        get { return defaults.string(forKey: ZCNUserDefaultsKey.usd.rawValue) }
        set { defaults.set(newValue, forKey: ZCNUserDefaultsKey.usd.rawValue) }
    }

    public static func set(_ value: Any, for key: ZCNUserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }

    public static func get(key: ZCNUserDefaultsKey) -> Any? {
        return defaults.value(forKey: key.rawValue)
    }

    public static func delete(key: ZCNUserDefaultsKey) {
        defaults.set(nil, forKey: key.rawValue)
    }
}
