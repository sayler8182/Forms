//
//  WDImageCropOverlayView.swift
//  FormsImagePicker
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: WDImageCropOverlayView
internal class WDImageCropOverlayView: UIView {
    var cropSize: CGSize = CGSize.zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.postInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.postInit()
    }
    
    private func postInit() {
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let width = self.frame.width
        let height = self.frame.height - 54.0 - UIView.safeArea.bottom
        let heightSpan: CGFloat = floor(height / 2 - self.cropSize.height / 2)
        let widthSpan: CGFloat = floor(width / 2 - self.cropSize.width / 2)

        // fill outer rect
        Theme.Colors.white.withAlphaComponent(0.5).set()
        UIRectFill(self.bounds)
        Theme.Colors.black.withAlphaComponent(0.5).set()
        UIRectFrame(CGRect(
            x: widthSpan - 2,
            y: heightSpan - 2,
            width: self.cropSize.width + 4,
            height: self.cropSize.height + 4))
        Theme.Colors.clear.set()
        UIRectFill(CGRect(
            x: widthSpan,
            y: heightSpan,
            width: self.cropSize.width,
            height: self.cropSize.height))
    }
}
