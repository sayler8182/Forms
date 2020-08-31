//
//  UIToolbar.swift
//  FormsUtilsUI
//
//  Created by Konrad on 8/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UIToolbar
public extension UIToolbar {
    convenience init(_ items: [UIBarButtonItem]) {
        self.init(frame: CGRect(width: 320, height: 44.0))
        self.items = items
        self.updateItems()
    }
    
    func updateItems() {
        self.items?
            .compactMap { $0 as? BarButtonItem }
            .forEach { $0 .superview = self }
    }
}

// MARK: Builder
public extension UIToolbar {
    func with(items: [UIBarButtonItem]) -> Self {
        self.items = items
        self.updateItems()
        return self
    }
}
