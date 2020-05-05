//
//  Theme.swift
//  Forms
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public protocol ThemeProtocol {
    var primaryDarkColor: UIColor { get }
    var primaryColor: UIColor { get }
    var primaryLightColor: UIColor { get }
    var primaryTextColor: UIColor { get }
    var secondaryColor: UIColor { get }
    var secondaryTextColor: UIColor { get }
    var textPrimaryColor: UIColor { get }
    var textSecondaryColor: UIColor { get }
    var dividerColor: UIColor { get }
    var errorColor: UIColor { get }
    
    var redColor: UIColor { get }
    var greenColor: UIColor { get }
}

public struct Theme: ThemeProtocol {
    public var primaryDarkColor: UIColor = UIColor(0xC2185B)
    public var primaryColor: UIColor = UIColor(0xE91E63)
    public var primaryLightColor: UIColor = UIColor(0xF8BBD0)
    public var primaryTextColor: UIColor = UIColor(0xFFFFFF)
    public var secondaryColor: UIColor = UIColor(0x448AFF)
    public var secondaryTextColor: UIColor = UIColor(0xFFFFFF)
    public var textPrimaryColor: UIColor = UIColor(0x212121)
    public var textSecondaryColor: UIColor = UIColor(0x757575)
    public var dividerColor: UIColor = UIColor(0xBDBDBD)
    public var errorColor: UIColor = UIColor(0xC62828)
    
    public var redColor: UIColor = UIColor(0xFF0A4F)
    public var greenColor: UIColor = UIColor(0x0DFF77)
}

public extension ThemeProtocol {
    static var label: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return UIColor(rgba: 0x000000ff)
        }
    }
    static var secondaryLabel: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.secondaryLabel
        } else {
            return UIColor(rgba: 0x3c3c4399)
        }
    }
    static var tertiaryLabel: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.tertiaryLabel
        } else {
            return UIColor(rgba: 0x3c3c434c)
        }
    }
    static var quaternaryLabel: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.quaternaryLabel
        } else {
            return UIColor(rgba: 0x3c3c432d)
        }
    }
    static var systemFill: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemFill
        } else {
            return UIColor(rgba: 0x78788033)
        }
    }
    static var secondarySystemFill: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.secondarySystemFill
        } else {
            return UIColor(rgba: 0x78788028)
        }
    }
    static var tertiarySystemFill: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.tertiarySystemFill
        } else {
            return UIColor(rgba: 0x7676801e)
        }
    }
    static var quaternarySystemFill: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.quaternarySystemFill
        } else {
            return UIColor(rgba: 0x74748014)
        }
    }
    static var placeholderText: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.placeholderText
        } else {
            return UIColor(rgba: 0x3c3c434c)
        }
    }
    static var systemBackground: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            return UIColor(rgba: 0xffffffff)
        }
    }
    static var secondarySystemBackground: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.secondarySystemBackground
        } else {
            return UIColor(rgba: 0xf2f2f7ff)
        }
    }
    static var tertiarySystemBackground: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.tertiarySystemBackground
        } else {
            return UIColor(rgba: 0xffffffff)
        }
    }
    static var systemGroupedBackground: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGroupedBackground
        } else {
            return UIColor(rgba: 0xf2f2f7ff)
        }
    }
    static var secondarySystemGroupedBackground: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.secondarySystemGroupedBackground
        } else {
            return UIColor(rgba: 0xffffffff)
        }
    }
    static var tertiarySystemGroupedBackground: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.tertiarySystemGroupedBackground
        } else {
            return UIColor(rgba: 0xf2f2f7ff)
        }
    }
    static var separator: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.separator
        } else {
            return UIColor(rgba: 0x3c3c4349)
        }
    }
    static var opaqueSeparator: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.opaqueSeparator
        } else {
            return UIColor(rgba: 0xc6c6c8ff)
        }
    }
    static var link: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.link
        } else {
            return UIColor(rgba: 0x007affff)
        }
    }
    static var darkText: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.darkText
        } else {
            return UIColor(rgba: 0x000000ff)
        }
    }
    static var lightText: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.lightText
        } else {
            return UIColor(rgba: 0xffffff99)
        }
    }
    static var systemBlue: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemBlue
        } else {
            return UIColor(rgba: 0x007affff)
        }
    }
    static var systemGreen: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGreen
        } else {
            return UIColor(rgba: 0x34c759ff)
        }
    }
    static var systemIndigo: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemIndigo
        } else {
            return UIColor(rgba: 0x5856d6ff)
        }
    }
    static var systemOrange: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemOrange
        } else {
            return UIColor(rgba: 0xff9500ff)
        }
    }
    static var systemPink: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemPink
        } else {
            return UIColor(rgba: 0xff2d55ff)
        }
    }
    static var systemPurple: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemPurple
        } else {
            return UIColor(rgba: 0xaf52deff)
        }
    }
    static var systemRed: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemRed
        } else {
            return UIColor(rgba: 0xff3b30ff)
        }
    }
    static var systemTeal: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemTeal
        } else {
            return UIColor(rgba: 0x5ac8faff)
        }
    }
    static var systemYellow: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemYellow
        } else {
            return UIColor(rgba: 0xffcc00ff)
        }
    }
    static var systemGray: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGray
        } else {
            return UIColor(rgba: 0x8e8e93ff)
        }
    }
    static var systemGray2: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGray2
        } else {
            return UIColor(rgba: 0xaeaeb2ff)
        }
    }
    static var systemGray3: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGray3
        } else {
            return UIColor(rgba: 0xc7c7ccff)
        }
    }
    static var systemGray4: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGray4
        } else {
            return UIColor(rgba: 0xd1d1d6ff)
        }
    }
    static var systemGray5: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGray5
        } else {
            return UIColor(rgba: 0xe5e5eaff)
        }
    }
    static var systemGray6: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGray6
        } else {
            return UIColor(rgba: 0xf2f2f7ff)
        }
    }
}
