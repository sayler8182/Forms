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
    
    convenience init(_ rgb: Int,
                     _ alpha: Int = 100) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha)
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
