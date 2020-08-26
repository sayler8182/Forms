//
//  ResizeableView.swift
//  FormsUtilsUI
//
//  Created by Konrad on 8/24/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: ResizeableView
open class ResizeableView: UIView {
    open var onResize: ((CGRect) -> Void)?
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        self.onResize?(rect)
    }
}
