//
//  GradientView.swift
//  Forms
//
//  Created by Konrad on 6/24/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import UIKit

// MARK: GradientView
open class GradientView: View {
    public let backgroundView = UIView()
        .with(isShimmerable: false)
    
    open var gradientColors: [UIColor?]? = nil {
        didSet { self.setNeedsDisplay() }
    }
    open var style: UIColor.GradientStyle = .linearHorizontal {
        didSet { self.setNeedsDisplay() }
    }
    
    override open func setupView() {
        self.setupBackgroundView()
        super.setupView()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let colors: [UIColor?] = self.gradientColors else { return }
        let frame: CGRect = self.bounds
        self.backgroundView.backgroundColor = UIColor(style: self.style, frame: frame, colors: colors)
    }
    
    open func setupBackgroundView() {
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
}

// MARK: Builder
public extension GradientView {
    func with(gradientColors: [UIColor?]?) -> Self {
        self.gradientColors = gradientColors
        return self
    }
    func with(style: UIColor.GradientStyle) -> Self {
        self.style = style
        return self
    }
}
