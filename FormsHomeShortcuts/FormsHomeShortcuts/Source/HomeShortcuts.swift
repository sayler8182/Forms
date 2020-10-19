//
//  HomeShortcuts.swift
//  FormsHomeShortcuts
//
//  Created by Konrad on 6/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: HomeShortcutsKeysProtocol
public protocol HomeShortcutsKeysProtocol {
    var item: HomeShortcutItem { get }
}

// MARK: HomeShortcutItem
public struct HomeShortcutItem {
    public let bundleIdentifier: String
    public let code: String
    public let title: String
    public let subtitle: String?
    public let icon: UIApplicationShortcutIcon?
    public let userInfo: [String: NSSecureCoding]?
    
    public var type: String {
        return String(format: "%@.%@", self.bundleIdentifier, self.code)
    }
    
    public init(bundleIdentifier: String,
                code: String,
                title: String,
                subtitle: String?,
                icon: UIApplicationShortcutIcon?,
                userInfo: [String: NSSecureCoding]?) {
        self.bundleIdentifier = bundleIdentifier
        self.code = code
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.userInfo = userInfo
    }
}

// MARK: HomeShortcutsProtocol
public protocol HomeShortcutsProtocol {
    var launchedShortcutItem: UIApplicationShortcutItem? { get }
    
    func launch(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func launch(_ shortcutItem: UIApplicationShortcutItem?)
    func handleIfNeeded(_ handle: (UIApplicationShortcutItem) -> Void)
    func dispose()
    func add(keys: [HomeShortcutsKeysProtocol])
    func add(key: HomeShortcutsKeysProtocol)
    func add(items: [HomeShortcutItem])
    func add(item: HomeShortcutItem)
    func remove(code: String)
    func removeAll()
    func contains(code: String) -> Bool
}
    
// MARK: HomeShortcuts
public class HomeShortcuts: HomeShortcutsProtocol {
    private static var launchedShortcutItem: UIApplicationShortcutItem? = nil
    
    public init() { }
    
    public var launchedShortcutItem: UIApplicationShortcutItem? {
        return Self.launchedShortcutItem
    }
    
    public func launch(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let item = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem
        self.launch(item)
    }
    
    public func launch(_ shortcutItem: UIApplicationShortcutItem?) {
        Self.launchedShortcutItem = shortcutItem
    }
    
    public func handleIfNeeded(_ handle: (UIApplicationShortcutItem) -> Void) {
        guard let shortcutItem: UIApplicationShortcutItem = Self.launchedShortcutItem else { return }
        self.dispose()
        handle(shortcutItem)
    }
    
    public func dispose() {
        Self.launchedShortcutItem = nil
    }
}

// MARK: Add / Remove
public extension HomeShortcuts {
    func add(keys: [HomeShortcutsKeysProtocol]) {
        for key in keys {
            self.add(key: key)
        }
    }
    
    func add(key: HomeShortcutsKeysProtocol) {
        self.add(item: key.item)
    }
    
    func add(items: [HomeShortcutItem]) {
        for item in items {
            self.add(item: item)
        }
    }
    
    func add(item: HomeShortcutItem) {
        guard !self.contains(code: item.code) else { return }
        var items: [UIApplicationShortcutItem] = UIApplication.shared.shortcutItems ?? []
        let item: UIApplicationShortcutItem = UIApplicationShortcutItem(
            type: item.type,
            localizedTitle: item.title,
            localizedSubtitle: item.subtitle,
            icon: item.icon,
            userInfo: item.userInfo)
        items.append(item)
        UIApplication.shared.shortcutItems = items
    }
    
    func remove(code: String) {
        var items: [UIApplicationShortcutItem] = UIApplication.shared.shortcutItems ?? []
        items = items.filter { !$0.type.hasSuffix(".\(code)") }
        UIApplication.shared.shortcutItems = items
    }
    
    func removeAll() {
        UIApplication.shared.shortcutItems = nil
    }
    
    func contains(code: String) -> Bool {
        let items: [UIApplicationShortcutItem] = UIApplication.shared.shortcutItems ?? []
        return items.contains { $0.type.hasSuffix(".\(code)") }
    }
}

// MARK: UIApplicationShortcutItem
public extension UIApplicationShortcutItem {
    var code: String? {
        return self.type.components(separatedBy: ".").last
    }
}
