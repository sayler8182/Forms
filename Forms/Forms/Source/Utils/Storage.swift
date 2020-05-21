//
//  Storage.swift
//  Forms
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation
import Security

// MARK: StorageKey
public protocol StorageKey {
    var rawValue: String { get }
}

// MARK: StorageProvider
public protocol StorageProvider {
    func clear()
}

// MARK: Storage
@propertyWrapper
public struct Storage<T>: StorageProvider {
    private let userDefaults = UserDefaults.standard
    private let key: StorageKey
    
    public init(_ key: StorageKey) {
        self.key = key
    }
    
    public var value: T? {
        get { return self.wrappedValue }
        set { self.wrappedValue = newValue }
    }
    
    public var wrappedValue: T? {
        get { return self.userDefaults.object(forKey: self.key.rawValue) as? T }
        set {
            self.userDefaults.set(newValue, forKey: self.key.rawValue)
            self.userDefaults.synchronize()
        }
    }
    
    public func clear() {
        self.userDefaults.removeObject(forKey: self.key.rawValue)
        self.userDefaults.synchronize()
    }
}

// MARK: StorageWithDefault
@propertyWrapper
public struct StorageWithDefault<T>: StorageProvider {
    private let userDefaults: UserDefaults = UserDefaults.standard
    private let key: StorageKey
    private let defaultValue: T
    
    public init(_ key: StorageKey,
                _ defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var value: T {
        get { return self.wrappedValue }
        set { self.wrappedValue = newValue }
    }
    
    public var wrappedValue: T {
        get { return self.userDefaults.object(forKey: self.key.rawValue) as? T ?? self.defaultValue }
        set {
            self.userDefaults.set(newValue, forKey: self.key.rawValue)
            self.userDefaults.synchronize()
        }
    }
    
    public func clear() {
        self.userDefaults.removeObject(forKey: self.key.rawValue)
        self.userDefaults.synchronize()
    }
}

// MARK: StorageKeychain
@propertyWrapper
public struct StorageKeychain<T: KeychainValue>: StorageProvider {
    private let key: StorageKey
    private let service: String
    private let group: String?
    private let accessibility: CFString?
    
    private var dictionary: [String: AnyObject] {
        var dictionary: [String: AnyObject] = [:]
        dictionary[kSecClass as String] = kSecClassGenericPassword as AnyObject
        dictionary[kSecAttrService as String] = self.service as AnyObject
        if let group: String = self.group {
            dictionary[kSecAttrAccessGroup as String] = group as AnyObject
        }
        if let accessibility: CFString = self.accessibility {
            dictionary[kSecAttrAccessible as String] = accessibility as AnyObject
        }
        if let keyData: Data = self.key.rawValue.data(using: .utf8) {
            dictionary[kSecAttrGeneric as String] = keyData as AnyObject
            dictionary[kSecAttrAccount as String] = keyData as AnyObject
        }
        return dictionary
    }
    
    public init(_ key: StorageKey,
                service: String = "com.limbo.forms",
                group: String? = nil,
                accessibility: CFString? = kSecAttrAccessibleAfterFirstUnlock) {
        self.key = key
        self.service = service
        self.group = group
        self.accessibility = accessibility
    }
    
    public var value: T? {
        get { return self.wrappedValue }
        set { self.wrappedValue = newValue }
    }
    
    public var wrappedValue: T? {
        get { return try? self.get() }
        set { try? self.set(newValue) }
    }
    
    public func clear() {
        try? self.delete()
    }
    
    private func get() throws -> T? {
        var dictionary: [String: AnyObject] = self.dictionary
        dictionary[kSecMatchLimit as String] = kSecMatchLimitOne
        dictionary[kSecReturnData as String] = true as AnyObject
        var result: AnyObject? = nil
        let status = SecItemCopyMatching(dictionary as CFDictionary, &result)
        guard status != errSecItemNotFound else { return nil }
        try self.validateStatus(status)
        guard let data: Data = result as? Data else { return nil }
        return try T(with: data)
    }
    
    private func set(_ value: T?) throws {
        guard let value: T = value else {
            try self.delete()
            return
        }
        var dictionary: [String: AnyObject] = self.dictionary
        dictionary[kSecValueData as String] = value.data as AnyObject
        let status: OSStatus = SecItemAdd(dictionary as CFDictionary, nil)
        if status == errSecDuplicateItem {
            try self.update(value)
        } else {
            try self.validateStatus(status)
        }
    }
    
    private func update(_ value: T) throws {
        var dictionary: [String: AnyObject] = [:]
        dictionary[kSecValueData as String] = value.data as AnyObject
        let status: OSStatus = SecItemUpdate(self.dictionary as CFDictionary, dictionary as CFDictionary)
        try self.validateStatus(status)
    }
    
    private func delete() throws {
        let status = SecItemDelete(self.dictionary as CFDictionary)
        guard status != errSecItemNotFound else { return }
        try self.validateStatus(status)
    }
    
    private func validateStatus(_ status: OSStatus) throws {
        let success: [OSStatus] = [noErr, errSecItemNotFound]
        guard !success.contains(status) else { return }
        throw KeychainError.error(status: status)
    }
}

// MARK: StorageKeychainWithDefault
@propertyWrapper
public struct StorageKeychainWithDefault<T: KeychainValue>: StorageProvider {
    private let key: StorageKey
    private let defaultValue: T
    private let service: String
    private let group: String?
    private let accessibility: CFString?
    
    private var dictionary: [String: AnyObject] {
        var dictionary: [String: AnyObject] = [:]
        dictionary[kSecClass as String] = kSecClassGenericPassword as AnyObject
        dictionary[kSecAttrService as String] = self.service as AnyObject
        if let group: String = self.group {
            dictionary[kSecAttrAccessGroup as String] = group as AnyObject
        }
        if let accessibility: CFString = self.accessibility {
            dictionary[kSecAttrAccessible as String] = accessibility as AnyObject
        }
        if let keyData: Data = self.key.rawValue.data(using: .utf8) {
            dictionary[kSecAttrGeneric as String] = keyData as AnyObject
            dictionary[kSecAttrAccount as String] = keyData as AnyObject
        }
        return dictionary
    }
    
    public init(_ key: StorageKey,
                _ defaultValue: T,
                service: String = "com.limbo.forms",
                group: String? = nil,
                accessibility: CFString? = kSecAttrAccessibleAfterFirstUnlock) {
        self.key = key
        self.defaultValue = defaultValue
        self.service = service
        self.group = group
        self.accessibility = accessibility
    }
    
    public var value: T {
        get { return self.wrappedValue }
        set { self.wrappedValue = newValue }
    }
    
    public var wrappedValue: T {
        get { return try! self.get() } // swiftlint:disable:this force_try
        set { try? self.set(newValue) }
    }
    
    public func clear() {
        try? self.delete()
    }
    
    private func get() throws -> T {
        var dictionary: [String: AnyObject] = self.dictionary
        dictionary[kSecMatchLimit as String] = kSecMatchLimitOne
        dictionary[kSecReturnData as String] = true as AnyObject
        var result: AnyObject? = nil
        let status = SecItemCopyMatching(dictionary as CFDictionary, &result)
        guard status != errSecItemNotFound else { return self.defaultValue }
        try self.validateStatus(status)
        guard let data: Data = result as? Data else { return self.defaultValue }
        return try T(with: data)
    }
    
    private func set(_ value: T?) throws {
        guard let value: T = value else {
            try self.delete()
            return
        }
        var dictionary: [String: AnyObject] = self.dictionary
        dictionary[kSecValueData as String] = value.data as AnyObject
        let status: OSStatus = SecItemAdd(dictionary as CFDictionary, nil)
        if status == errSecDuplicateItem {
            try self.update(value)
        } else {
            try self.validateStatus(status)
        }
    }
    
    private func update(_ value: T) throws {
        var dictionary: [String: AnyObject] = [:]
        dictionary[kSecValueData as String] = value.data as AnyObject
        let status: OSStatus = SecItemUpdate(self.dictionary as CFDictionary, dictionary as CFDictionary)
        try self.validateStatus(status)
    }
    
    private func delete() throws {
        let status = SecItemDelete(self.dictionary as CFDictionary)
        guard status != errSecItemNotFound else { return }
        try self.validateStatus(status)
    }
    
    private func validateStatus(_ status: OSStatus) throws {
        let success: [OSStatus] = [noErr, errSecItemNotFound]
        guard !success.contains(status) else { return }
        throw KeychainError.error(status: status)
    }
}

// MARK: KeychainError
public enum KeychainError: Error {
    case invalidData
    case error(status: OSStatus)
}

// MARK: KeychainValue
public protocol KeychainValue {
    var data: Data { get }
    
    init(with data: Data) throws
}

// MARK: KeychainValue - Extensions
extension String: KeychainValue {
    public var data: Data {
        return self.data(using: .utf8) ?? Data()
    }
    
    public init(with data: Data) throws {
        self.init(data: data, encoding: .utf8)! // swiftlint:disable:this force_unwrapping
    }
}
