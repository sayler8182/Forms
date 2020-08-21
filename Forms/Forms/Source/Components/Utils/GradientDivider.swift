//
//  GradientDivider.swift
//  Forms
//
//  Created by Konrad on 6/26/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import UIKit

// MARK: GradientDivider
open class GradientDivider: Divider {
    open var colors: [UIColor?]? = nil {
        didSet { self.setNeedsDisplay() }
    }
    open var style: UIColor.GradientStyle = .linearHorizontal {
        didSet { self.setNeedsDisplay() }
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let colors: [UIColor?] = self.colors else { return }
        let frame: CGRect = self.bounds
        self.backgroundView.backgroundColor = UIColor(style: self.style, frame: frame, colors: colors)
    } 
}

// MARK: Builder
public extension GradientDivider {
    func with(colors: [UIColor?]?) -> Self {
        self.colors = colors
        return self
    }
    func with(style: UIColor.GradientStyle) -> Self {
        self.style = style
        return self
    }
}
