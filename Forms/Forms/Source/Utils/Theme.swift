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
