//
//  SettingsBundle.swift
//  Forms
//
//  Created by Konrad on 8/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: SettingsBundleKey
public protocol SettingsBundleKey {
    var rawValue: String { get }
}

// MARK: SettingsBundleProtocol
public protocol SettingsBundleProtocol {
    func get<T: Any>(forKey key: SettingsBundleKey) -> T?
    func set<T: Any>(value: T?, forKey key: SettingsBundleKey)
}
    
// MARK: SettingsBundle
public class SettingsBundle: SettingsBundleProtocol {
    private let userDefaults = UserDefaults.standard
    
    public init() { }
    
    public func get<T: Any>(forKey key: SettingsBundleKey) -> T? {
        return self.userDefaults.object(forKey: key.rawValue) as? T
    }
    
    public func get<T: Decodable>(forKey key: SettingsBundleKey) -> T? {
        return self.userDefaults.decodable(forKey: key.rawValue, of: T.self)
    }
    
    public func set<T: Any>(value: T?, forKey key: SettingsBundleKey) {
        self.userDefaults.set(value, forKey: key.rawValue)
        self.userDefaults.synchronize()
    }
    
    public func set<T: Encodable>(value: T?, forKey key: SettingsBundleKey) {
        self.userDefaults.encodable(value, forKey: key.rawValue)
        self.userDefaults.synchronize()
    }
}
