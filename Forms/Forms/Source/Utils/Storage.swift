//
//  Storage.swift
//  Forms
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import Foundation
import Security

// MARK: StorageContainerProtocol
public protocol StorageContainerProtocol {
    func get<T: Any>(forKey key: StorageKey) -> T?
    func set<T: Any>(value: T?, forKey key: StorageKey)
    func remove(forKey key: StorageKey)
}

// MARK: StorageUserDefaults
public class StorageUserDefaultsContainer: StorageContainerProtocol, StorageSecureContainerProtocol {
    private let userDefaults = UserDefaults.standard
    public static let shared = StorageUserDefaultsContainer()
    
    private init() { }
    
    public func get<T: Any>(forKey key: StorageKey) -> T? {
        return self.userDefaults.object(forKey: key.rawValue) as? T
    }
    
    public func set<T: Any>(value: T?, forKey key: StorageKey) {
        self.userDefaults.set(value, forKey: key.rawValue)
        self.userDefaults.synchronize()
    }
    
    public func remove(forKey key: StorageKey) {
        self.userDefaults.removeObject(forKey: key.rawValue)
        self.userDefaults.synchronize()
    }
    
    public func get<T: KeychainValue>(info: StorageSecureInfo) throws -> T? {
        return self.get(forKey: info.key)
    }
    
    public func set<T: KeychainValue>(value: T?, info: StorageSecureInfo) throws {
        return self.set(value: value, forKey: info.key)
    }
    
    public func remove(info: StorageSecureInfo) throws {
        return self.remove(forKey: info.key)
    }
}

// MARK: StorageSecureInfo
public struct StorageSecureInfo {
    var key: StorageKey
    var service: String
    var group: String?
    var accessibility: CFString?
}

// MARK: StorageSecureContainerProtocol
public protocol StorageSecureContainerProtocol {
    func get<T: KeychainValue>(info: StorageSecureInfo) throws -> T?
    func set<T: KeychainValue>(value: T?,
                               info: StorageSecureInfo) throws
    func remove(info: StorageSecureInfo) throws
}

// MARK: StorageKeychainContainer
public class StorageKeychainContainer: StorageSecureContainerProtocol {
    public static let shared = StorageKeychainContainer()
    
    private init() { }
    
    public func get<T: KeychainValue>(info: StorageSecureInfo) throws -> T? {
        var dictionary: [String: AnyObject] = self.dictionary(info: info)
        dictionary[kSecMatchLimit as String] = kSecMatchLimitOne
        dictionary[kSecReturnData as String] = true as AnyObject
        var result: AnyObject? = nil
        let status = SecItemCopyMatching(dictionary as CFDictionary, &result)
        guard status != errSecItemNotFound else { return nil }
        try self.validateStatus(status)
        guard let data: Data = result as? Data else { return nil }
        return try T(with: data)
    }
    
    public func set<T: KeychainValue>(value: T?,
                                      info: StorageSecureInfo) throws {
        guard let value: T = value else {
            try self.remove(info: info)
            return
        }
        var dictionary = self.dictionary(info: info)
        dictionary[kSecValueData as String] = value.data as AnyObject
        let status: OSStatus = SecItemAdd(dictionary as CFDictionary, nil)
        if status == errSecDuplicateItem {
            try self.update(value, info: info)
        } else {
            try self.validateStatus(status)
        }
    }
    
    public func remove(info: StorageSecureInfo) throws {
        let dictionary = self.dictionary(info: info) as CFDictionary
        let status = SecItemDelete(dictionary)
        guard status != errSecItemNotFound else { return }
        try self.validateStatus(status)
    }
    
    private func update<T: KeychainValue>(_ value: T,
                                          info: StorageSecureInfo) throws {
        let oldDictionary = self.dictionary(info: info) as CFDictionary
        var newDictionary: [String: AnyObject] = [:]
        newDictionary[kSecValueData as String] = value.data as AnyObject
        let status: OSStatus = SecItemUpdate(oldDictionary, newDictionary as CFDictionary)
        try self.validateStatus(status)
    }
    
    private func dictionary(info: StorageSecureInfo) -> [String: AnyObject] {
        var dictionary: [String: AnyObject] = [:]
        dictionary[kSecClass as String] = kSecClassGenericPassword as AnyObject
        dictionary[kSecAttrService as String] = info.service as AnyObject
        if let group: String = info.group {
            dictionary[kSecAttrAccessGroup as String] = group as AnyObject
        }
        if let accessibility: CFString = info.accessibility {
            dictionary[kSecAttrAccessible as String] = accessibility as AnyObject
        }
        if let keyData: Data = info.key.rawValue.data(using: .utf8) {
            dictionary[kSecAttrGeneric as String] = keyData as AnyObject
            dictionary[kSecAttrAccount as String] = keyData as AnyObject
        }
        return dictionary
    }
    
    private func validateStatus(_ status: OSStatus) throws {
        let success: [OSStatus] = [noErr, errSecItemNotFound]
        guard !success.contains(status) else { return }
        throw KeychainError.error(status: status)
    }
}

// MARK: StorageKey
public protocol StorageKey {
    var rawValue: String { get }
}

// MARK: StorageProvider
public protocol StorageProvider {
    func remove()
}

// MARK: Storage
@propertyWrapper
public struct Storage<T>: StorageProvider {
    private let container: StorageContainerProtocol = {
        let container: StorageContainerProtocol? = Injector.main.resolveOrDefault("Forms")
        return container ?? StorageUserDefaultsContainer.shared
    }()
    private let key: StorageKey
    
    public init(_ key: StorageKey) {
        self.key = key
    }
    
    public var value: T? {
        get { return self.wrappedValue }
        set { self.wrappedValue = newValue }
    }
    
    public var wrappedValue: T? {
        get { return self.container.get(forKey: self.key) }
        set { self.container.set(value: newValue, forKey: self.key) }
    }
    
    public func remove() {
        self.container.remove(forKey: self.key)
    }
}

// MARK: StorageWithDefault
@propertyWrapper
public struct StorageWithDefault<T>: StorageProvider {
    private let container: StorageContainerProtocol = {
        let container: StorageContainerProtocol? = Injector.main.resolveOrDefault("Forms")
        return container ?? StorageUserDefaultsContainer.shared
    }()
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
        get { return self.container.get(forKey: self.key) ?? self.defaultValue }
        set { self.container.set(value: newValue, forKey: self.key) }
    }
    
    public func remove() {
        self.container.remove(forKey: self.key)
    }
}

// MARK: StorageSecure
@propertyWrapper
public struct StorageSecure<T: KeychainValue>: StorageProvider {
    private let container: StorageSecureContainerProtocol = {
        let container: StorageSecureContainerProtocol? = Injector.main.resolveOrDefault("Forms")
        return container ?? StorageKeychainContainer.shared
    }()
    private let info: StorageSecureInfo
     
    public init(_ key: StorageKey,
                service: String = "com.limbo.forms",
                group: String? = nil,
                accessibility: CFString? = kSecAttrAccessibleAfterFirstUnlock) {
        self.info = StorageSecureInfo(
            key: key,
            service: service,
            group: group,
            accessibility: accessibility)
    }
    
    public var value: T? {
        get { return self.wrappedValue }
        set { self.wrappedValue = newValue }
    }
    
    public var wrappedValue: T? {
        get { return try? self.container.get(info: self.info) }
        set { try? self.container.set(value: newValue, info: self.info) }
    }
    
    public func remove() {
        try? self.container.remove(info: self.info)
    }
}

// MARK: StorageSecureWithDefault
@propertyWrapper
public struct StorageSecureWithDefault<T: KeychainValue>: StorageProvider {
    private let container: StorageSecureContainerProtocol = {
        let container: StorageSecureContainerProtocol? = Injector.main.resolveOrDefault("Forms")
        return container ?? StorageKeychainContainer.shared
    }()
    private let info: StorageSecureInfo
    private let defaultValue: T
    
    public init(_ key: StorageKey,
                _ defaultValue: T,
                service: String = "com.limbo.forms",
                group: String? = nil,
                accessibility: CFString? = kSecAttrAccessibleAfterFirstUnlock) {
        self.info = StorageSecureInfo(
            key: key,
            service: service,
            group: group,
            accessibility: accessibility)
        self.defaultValue = defaultValue
    }
    
    public var value: T {
        get { return self.wrappedValue }
        set { self.wrappedValue = newValue }
    }
    
    public var wrappedValue: T {
        get { return (try? self.container.get(info: self.info)) ?? self.defaultValue }
        set { try? self.container.set(value: newValue, info: self.info) }
    }
    
    public func remove() {
        try? self.container.remove(info: self.info)
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
