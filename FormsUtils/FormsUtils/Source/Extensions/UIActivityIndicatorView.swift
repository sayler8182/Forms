//
//  UIActivityIndicatorView.swift
//  Forms
//
//  Created by Konrad on 4/7/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: Builder
public extension UIActivityIndicatorView {
    func with(color: UIColor) -> Self {
        self.color = color
        return self
    }
    func with(isAnimating: Bool) -> Self {
        isAnimating
            ? self.startAnimating()
            : self.stopAnimating()
        return self
    }
    func with(style: UIActivityIndicatorView.Style) -> Self {
        self.style = style
        return self
    }
}
