//
//  WDImageCropBorderView.swift
//  FormsImagePicker
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: WDImageCropBorderView
internal class WDImageCropBorderView: UIView {
    fileprivate let diameter: CGFloat = 24.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.postInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.postInit()
    }
    
    private func postInit() {
        self.backgroundColor = Theme.Colors.clear
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(UIColor.white.with(alpha: 0.5).cgColor)
        context.setLineWidth(1.5)
        context.addRect(CGRect(
            x: self.diameter / 2,
            y: self.diameter / 2,
            width: rect.size.width - self.diameter,
            height: rect.size.height - self.diameter))
        context.strokePath()

        context.setFillColor(UIColor.white.with(alpha: 0.5).cgColor)
        let rects: [CGRect] = self.allRects()
        for rect in rects {
            context.fillEllipse(in: rect)
        }
    }

    fileprivate func allRects() -> [CGRect] {
        let width: CGFloat = self.frame.width
        let height: CGFloat = self.frame.height
        return [
            CGRect(x: 0, y: 0, width: self.diameter, height: self.diameter),
            CGRect(x: (width - self.diameter) / 2, y: 0, width: self.diameter, height: self.diameter),
            CGRect(x: width - self.diameter, y: 0, width: self.diameter, height: self.diameter),
            CGRect(x: width - self.diameter, y: (height - self.diameter) / 2, width: self.diameter, height: self.diameter),
            CGRect(x: width - self.diameter, y: height - self.diameter, width: self.diameter, height: self.diameter),
            CGRect(x: (width - self.diameter) / 2, y: height - self.diameter, width: self.diameter, height: self.diameter),
            CGRect(x: 0, y: height - self.diameter, width: self.diameter, height: self.diameter),
            CGRect(x: 0, y: (height - self.diameter) / 2, width: self.diameter, height: self.diameter)
        ]
    }
}
