//
//  Divider.swift
//  Forms
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: Divider
open class Divider: Component {
    open var color: UIColor? {
        get { return self.backgroundColor }
        set { self.backgroundColor = newValue }
    }
    open var height: CGFloat = 1
    
    override open func setupView() {
        self.setupComponent()
        super.setupView()
    }
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
    
    private func setupComponent() {
        self.anchors([
            Anchor.to(self).fill
        ])
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
