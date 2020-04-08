//
//  UILabel.swift
//  Utils
//
//  Created by Konrad on 4/7/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: Builder
public extension UILabel {
    func with(font: UIFont) -> Self {
        self.font = font
        return self
    }
    func with(numberOfLines: Int) -> Self {
        self.numberOfLines = numberOfLines
        return self
    }
    func with(textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    func with(textColor: UIColor?) -> Self {
        self.textColor = textColor
        return self
    }
}
