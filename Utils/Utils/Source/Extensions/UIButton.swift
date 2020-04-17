//
//  UIButton.swift
//  Utils
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: Builder
public extension UIButton {
    func with(titleColor: UIColor?) -> Self {
        self.setTitleColor(titleColor, for: .normal)
        return self
    }
    func with(titleFont: UIFont) -> Self {
        self.titleLabel?.font = titleFont
        return self
    }
}
