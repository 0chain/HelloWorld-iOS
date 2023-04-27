//
//  UserdefaultManager.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 27/04/23.
//

import Foundation
import Combine

struct UserdefaultManager {
    @UserDefault(Utils.UserDefaultsKey.balance.rawValue) var balance: Int = 0
}


@propertyWrapper
final class UserDefault<T>: NSObject {
    // This ensures requirement 1 is fulfilled. The wrapped value is stored in user defaults.
    var wrappedValue: T {
        get {
            return userDefaults.object(forKey: key) as! T
        }
        set {
            userDefaults.setValue(newValue, forKey: key)
        }
    }
    var projectedValue: AnyPublisher<T, Never> {
        return subject.eraseToAnyPublisher()
    }

    private let key: String
    private let userDefaults: UserDefaults
    private var observerContext = 0
    private let subject: CurrentValueSubject<T, Never>

    init(wrappedValue defaultValue: T, _ key: String, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.userDefaults = userDefaults
        self.subject = CurrentValueSubject(defaultValue)
        super.init()
        userDefaults.register(defaults: [key: defaultValue])
        // This fulfills requirement 4. Some implementations use NSUserDefaultsDidChangeNotification
        // but that is sent every time any value is updated in UserDefaults.
        userDefaults.addObserver(self, forKeyPath: key, options: .new, context: &observerContext)
        subject.value = wrappedValue
    }

    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?) {
        if context == &observerContext {
            subject.value = wrappedValue
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    deinit {
        userDefaults.removeObserver(self, forKeyPath: key, context: &observerContext)
    }
}