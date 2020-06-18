//
//  Divider.swift
//  Forms
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import UIKit

// MARK: Divider
open class Divider: FormsComponent, UnShimmerable {
    open var color: UIColor? {
        get { return self.backgroundColor }
        set { self.backgroundColor = newValue }
    }
    open var height: CGFloat = 1
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
}

// MARK: Builder
public extension Divider {
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(color: UIColor?) -> Self {
        self.color = color
        return self
    }
}
