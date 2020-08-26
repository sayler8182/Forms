//
//  Theme.swift
//  Forms
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import UIKit

// MARK: ThemeType
public enum ThemeType {
    case light
    case dark
    case custom(_ key: String)
    
    public init?(_ style: Int?) {
        switch style {
        case 1: self = ThemeType.light
        case 2: self = ThemeType.dark
        default: return nil
        }
    }
    
    public init?(_ key: String?) {
        guard let key: String = key, key.isNotEmpty else { return nil }
        switch key {
        case ThemeType.light.key: self = ThemeType.light
        case ThemeType.dark.key: self = ThemeType.dark
        default: self = ThemeType.custom(key)
        }
    }
    
    public var style: Int {
        switch self {
        case .light: return 1
        case .dark: return 2
        case .custom: return -1
        }
    }
    
    public var key: String {
        switch self {
        case .light: return "LIGHT"
        case .dark: return "DARK"
        case .custom(let key): return key
        }
    }
}

// MARK: ThemeProtocol
public protocol ThemeProtocol {
    static var Colors: ThemeColorsProtocol { get }
    
    @available(iOS 12.0, *)
    static func setUserInterfaceStyle(_ userInterfaceStryle: UIUserInterfaceStyle)
    static func setTheme(_ theme: ThemeType?)
}

// MARK: Theme
public class Theme: ThemeProtocol {
    fileprivate static var observers: [ThemeObserver] = []
    fileprivate static var systemTheme: ThemeType = ThemeType.light
    
    fileprivate static var theme: ThemeType? {
        get {
            let themeKey: String? = UserDefaults.standard.object(forKey: "FormsThemeTypeKey") as? String
            return ThemeType(themeKey)
        }
        set {
            if let themeKey: String = newValue?.key {
                UserDefaults.standard.set(themeKey, forKey: "FormsThemeTypeKey")
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.removeObject(forKey: "FormsThemeTypeKey")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    public static var Colors: ThemeColorsProtocol {
        let themeKey: String = Self.theme?.key ?? Self.systemTheme.key
        if let colors: ThemeColorsProtocol = Injector.main.resolve(themeKey) {
            return colors
        } else if let colors: ThemeColorsProtocol = Injector.main.resolveOrDefault("Forms") {
            return colors
        } else {
            return ThemeColors()
        }
    }
    
    public static var Fonts: ThemeFontsProtocol {
        let themeKey: String = Self.theme?.key ?? Self.systemTheme.key
        if let fonts: ThemeFontsProtocol = Injector.main.resolve(themeKey) {
            return fonts
        } else if let fonts: ThemeFontsProtocol = Injector.main.resolveOrDefault("Forms") {
            return fonts
        } else {
            return ThemeFonts()
        }
    }
    
    @available(iOS 12.0, *)
    public static func setUserInterfaceStyle(_ userInterfaceStyle: UIUserInterfaceStyle) {
        guard Self.systemTheme.style != userInterfaceStyle.rawValue else { return }
        guard let theme: ThemeType = ThemeType(userInterfaceStyle.rawValue) else { return }
        Self.systemTheme = theme
        Self.clean()
        guard self.theme.isNil else { return }
        Self.observers.setTheme()
    }
    
    public static func setTheme(_ theme: ThemeType?) {
        guard Self.theme?.key != theme?.key else { return }
        Self.theme = theme
        Self.clean()
        Self.observers.setTheme()
    }
}

// MARK: Themeable
public protocol Themeable: class {
    func setTheme()
}

// MARK: ThemeObserver
private class ThemeObserver {
    fileprivate weak var item: Themeable?
    
    fileprivate init(_ item: Themeable) {
        self.item = item
    }
}

// MARK: [ThemeObserver]
private extension Array where Element == ThemeObserver {
    func setTheme() {
        for item in self {
            item.item?.setTheme()
        }
    }
}

// MARK: Observers
public extension Theme {
    static func register(_ item: Themeable) {
        let observer = ThemeObserver(item)
        Self.observers.append(observer)
        Self.clean()
    }
    
    static func unregister(_ item: Themeable) {
        self.observers
            .filter { $0.item === item }
            .forEach { $0.item = nil }
        Self.clean()
    }
    
    private static func clean() {
        Self.observers = Self.observers
            .filter { $0.item != nil }
    }
}

// MARK: ThemeColorsKey
public struct ThemeColorsKey: Hashable {
    public static var black = ThemeColorsKey("black")
    public static var blue = ThemeColorsKey("blue")
    public static var clear = ThemeColorsKey("clear")
    public static var gray = ThemeColorsKey("gray")
    public static var green = ThemeColorsKey("green")
    public static var orange = ThemeColorsKey("orange")
    public static var red = ThemeColorsKey("red")
    public static var white = ThemeColorsKey("white")
    
    public static var primaryDark = ThemeColorsKey("primaryDark")
    public static var secondaryDark = ThemeColorsKey("secondaryDark")
    public static var tertiaryDark = ThemeColorsKey("tertiaryDark")
    
    public static var primaryLight = ThemeColorsKey("primaryLight")
    public static var secondaryLight = ThemeColorsKey("secondaryLight")
    public static var tertiaryLight = ThemeColorsKey("tertiaryLight")
    
    public let key: String
    
    public init(_ key: String) {
        self.key = key
    }
}

// MARK: ThemeBarStyle
public enum ThemeBarStyle {
    case light
    case dark
    
    public var style: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            switch self {
            case .light:
                return .lightContent
            case .dark:
                return .darkContent
            }
        } else {
            return .default
        }
    }
}

// MARK: ThemeColorsProtocol
public protocol ThemeColorsProtocol {
    var colors: [ThemeColorsKey: UIColor] { get }
    var statusBar: ThemeBarStyle { get }
    
    func register(_ colors: [ThemeColorsKey: UIColor])
    func color(_ key: ThemeColorsKey) -> UIColor
    func color(_ key: ThemeColorsKey,
               or defaultValue: UIColor) -> UIColor
}

// MARK: ThemeColors
public class ThemeColors: ThemeColorsProtocol {
    public private (set) var colors: [ThemeColorsKey: UIColor]
    public private (set) var statusBar: ThemeBarStyle
    
    public init(colors: [ThemeColorsKey: UIColor] = [:],
                statusBar: ThemeBarStyle = .dark) {
        self.colors = colors
        self.statusBar = statusBar
    }
    
    public func register(_ colors: [ThemeColorsKey: UIColor]) {
        for color in colors {
            self.colors[color.key] = color.value
        }
    }
    
    public func color(_ key: ThemeColorsKey) -> UIColor {
        return self.color(key, or: UIColor.clear)
    }
    
    public func color(_ key: ThemeColorsKey,
                      or defaultValue: UIColor) -> UIColor {
        return self.colors[key] ?? defaultValue
    }
}

// MARK: ThemeFontsKey
public struct ThemeFontsKey: Hashable {
    public static var bold = ThemeFontsKey("bold")
    public static var light = ThemeFontsKey("light")
    public static var medium = ThemeFontsKey("medium")
    public static var regular = ThemeFontsKey("regular")
    
    let key: String
    
    public init(_ key: String) {
        self.key = key
    }
}

// MARK: ThemeFontsProtocol
public protocol ThemeFontsProtocol {
    typealias ThemeFont = (_ size: CGFloat) -> UIFont
    
    var fonts: [ThemeFontsKey: ThemeFont] { get }
    
    func register(_ fonts: [ThemeFontsKey: ThemeFont])
    func font(_ key: ThemeFontsKey,
              ofSize size: CGFloat) -> UIFont
    func font(_ key: ThemeFontsKey,
              ofSize size: CGFloat,
              or defaultValue: UIFont) -> UIFont
}

// MARK: ThemeFonts
public class ThemeFonts: ThemeFontsProtocol {
    public private (set) var fonts: [ThemeFontsKey: ThemeFont]
    
    public init(fonts: [ThemeFontsKey: ThemeFont] = [:]) {
        self.fonts = fonts
    }
    
    public func register(_ fonts: [ThemeFontsKey: ThemeFont]) {
        for font in fonts {
            self.fonts[font.key] = font.value
        }
    }
    
    public func font(_ key: ThemeFontsKey,
                     ofSize size: CGFloat) -> UIFont {
        return self.font(key, ofSize: size, or: UIFont.systemFont(ofSize: size))
    }
    
    public func font(_ key: ThemeFontsKey,
                     ofSize size: CGFloat,
                     or defaultValue: UIFont) -> UIFont {
        return self.fonts[key]?(size) ?? defaultValue
    }
}

// MARK: Colors
public extension ThemeColorsProtocol {
    var black: UIColor {
        return self.color(.black, or: UIColor(rgba: 0x000000FF))
    }
    var blue: UIColor {
        return self.color(.blue, or: UIColor(rgba: 0x007AFFFF))
    }
    var clear: UIColor {
        return self.color(.clear, or: UIColor(rgba: 0xFFFFFF00))
    }
    var gray: UIColor {
        return self.color(.gray, or: UIColor(rgba: 0x8E8E93FF))
    }
    var green: UIColor {
        return self.color(.green, or: UIColor(rgba: 0x34C759FF))
    }
    var orange: UIColor {
        return self.color(.orange, or: UIColor(rgba: 0xFFA500FF))
    }
    var red: UIColor {
        return self.color(.red, or: UIColor(rgba: 0xFF3B30FF))
    }
    var white: UIColor {
        return self.color(.white, or: UIColor(rgba: 0xFFFFFFFF))
    }
    
    var primaryDark: UIColor {
        return self.color(.primaryDark, or: UIColor(rgba: 0x000000FF))
    }
    var secondaryDark: UIColor {
        return self.color(.secondaryDark, or: UIColor(rgba: 0x3C3C43FF))
    }
    var tertiaryDark: UIColor {
        return self.color(.tertiaryDark, or: UIColor(rgba: 0x5C5C63FF))
    }
    
    var primaryLight: UIColor {
        return self.color(.primaryLight, or: UIColor(rgba: 0xFFFFFFFF))
    }
    var secondaryLight: UIColor {
        return self.color(.secondaryLight, or: UIColor(rgba: 0xF2F2F7FF))
    }
    var tertiaryLight: UIColor {
        return self.color(.tertiaryLight, or: UIColor(rgba: 0xE2E2E2FF))
    }
}

// MARK: Fonts
public extension ThemeFontsProtocol {
    func bold(ofSize size: CGFloat) -> UIFont {
        return self.font(.bold, ofSize: size, or: UIFont.boldSystemFont(ofSize: size))
    }
    func regular(ofSize size: CGFloat) -> UIFont {
        return self.font(.regular, ofSize: size, or: UIFont.systemFont(ofSize: size))
    }
}

// MARK: UITableView
extension UITableView: Themeable {
    public func setTheme() {
        self.reloadData()
    }
}

// MARK: UICollectionView
extension UICollectionView: Themeable {
    public func setTheme() {
        self.reloadData()
    }
}
