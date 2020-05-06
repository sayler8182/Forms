//
//  UIColor.swift
//  Utils
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UIColor
public extension UIColor {
    var transparent: UIColor {
        return self.withAlphaComponent(0.0)
    }
    
    var image: UIImage? {
        return UIImage(color: self)
    }
    
    convenience init(_ rgbDark: Int,
                     _ darkAlpha: Int = 100,
                     _ rgbLight: Int,
                     _ lightAlpha: Int = 100) {
        if #available(iOS 13.0, *) {
            self.init { (trait) -> UIColor in
                return trait.userInterfaceStyle == .dark
                    ? UIColor(rgbDark, darkAlpha)
                    : UIColor(rgbLight, lightAlpha)
            }
        } else {
            self.init(rgbLight, lightAlpha)
        }
    }
    
    convenience init(rgbaDark: UInt,
                     rgbaLight: UInt) {
        if #available(iOS 13.0, *) {
            self.init { (trait) -> UIColor in
                return trait.userInterfaceStyle == .dark
                    ? UIColor(rgba: rgbaDark)
                    : UIColor(rgba: rgbaLight)
            }
        } else {
            self.init(rgba: rgbaLight)
        }
    }
    
    convenience init(_ rgb: Int,
                     _ alpha: Int = 100) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha)
    }
    
    convenience init(rgba: UInt) {
        self.init(
            red: Int((rgba >> 24) & 0xFF),
            green: Int((rgba >> 16) & 0xFF),
            blue: Int((rgba >> 8) & 0xFF),
            alpha: Int(rgba & 0xFF))
    }
    
    private convenience init(red: Int,
                             green: Int,
                             blue: Int,
                             alpha: Int = 100) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha) / 100.0)
    }
}
