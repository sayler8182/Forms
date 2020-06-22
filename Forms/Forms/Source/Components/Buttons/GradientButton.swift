//
//  GradientButton.swift
//  Forms
//
//  Created by Konrad on 6/19/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: GradientButton
open class GradientButton: Button {
    open var gradientColors: Button.State<[UIColor?]>? = nil {
        didSet { self.setNeedsDisplay() }
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let colors: Button.State<[UIColor?]> = self.gradientColors else { return }
        let frame: CGRect = self.backgroundView.bounds
        self.backgroundColors = Button.State<UIColor?>()
            .with(active: UIColor(style: .linear, frame: frame, colors: colors.value(for: .active)))
            .with(selected: UIColor(style: .linear, frame: frame, colors: colors.value(for: .selected)))
            .with(disabled: UIColor(style: .linear, frame: frame, colors: colors.value(for: .disabled)))
            .with(loading: UIColor(style: .linear, frame: frame, colors: colors.value(for: .loading)))
    } 
}

// MARK: Builder
public extension GradientButton {
    func with(gradientColors: [UIColor?]) -> Self {
        self.gradientColors = Button.State<[UIColor?]>(gradientColors)
        return self
    }
    func with(gradientColors: Button.State<[UIColor?]>?) -> Self {
        self.gradientColors = gradientColors
        return self
    }
}
