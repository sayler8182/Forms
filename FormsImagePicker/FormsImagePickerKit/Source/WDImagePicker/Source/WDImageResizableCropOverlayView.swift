//
//  WDImageResizableCropOverlayView.swift
//  FormsImagePicker
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: WDImageResizableViewBorderMultiplyer
private struct WDImageResizableViewBorderMultiplyer {
    var widthMultiplyer: CGFloat = 1.0
    var heightMultiplyer: CGFloat = 1.0
    var xMultiplyer: CGFloat = 1.0
    var yMultiplyer: CGFloat = 1.0
}

// MARK: WDImageResizableCropOverlayView
internal class WDImageResizableCropOverlayView: WDImageCropOverlayView {
    fileprivate let kBorderCorrectionValue: CGFloat = 12

    private (set) var contentView: UIView = UIView()
    private (set) var cropBorderView: WDImageCropBorderView = WDImageCropBorderView()

    fileprivate var initialContentSize: CGSize = CGSize.zero
    fileprivate var resizingEnabled: Bool = false
    fileprivate var anchor: CGPoint = CGPoint.zero
    fileprivate var startPoint: CGPoint = CGPoint.zero
    fileprivate var resizeMultiplyer = WDImageResizableViewBorderMultiplyer()

    override var frame: CGRect {
        get { return super.frame }
        set {
            super.frame = newValue
            self.updateFrame()
        }
    }

    init(frame: CGRect, initialContentSize: CGSize) {
        super.init(frame: frame)
        self.initialContentSize = initialContentSize
        self.setupContentViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch: UITouch = touches.first else { return }
        let touchPoint: CGPoint = touch.location(in: self.cropBorderView)
        self.anchor = self.calculateAnchorBorder(touchPoint)
        self.fillMultiplyer()
        self.resizingEnabled = true
        self.startPoint = touch.location(in: self.superview)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch: UITouch = touches.first else { return }
        guard self.resizingEnabled else { return }
        let touchPoint: CGPoint = touch.location(in: self.superview)
        self.resizeWithTouchPoint(touchPoint)
    }

    override func draw(_ rect: CGRect) {
        Theme.Colors.white.with(alpha: 0.5).set()
        UIRectFill(self.bounds)
        Theme.Colors.clear.set()
        UIRectFill(self.contentView.frame)
    }

    fileprivate func setupContentViews() {
        self.updateFrame()
        self.contentView.backgroundColor = Theme.Colors.clear
        self.cropSize = self.contentView.frame.size
        self.addSubview(self.contentView)
        self.addSubview(self.cropBorderView)
    }
    
    private func updateFrame() {
        let toolbarSize: CGFloat = 54.0 + UIView.safeArea.bottom
        let width: CGFloat = self.bounds.size.width
        let height: CGFloat = self.bounds.size.height
        
        self.contentView.frame = CGRect(
            x: (width - self.initialContentSize.width) / 2,
            y: (height - toolbarSize - self.initialContentSize.height) / 2,
            width: self.initialContentSize.width,
            height: self.initialContentSize.height)
        self.cropBorderView.frame = CGRect(
            x: (width - self.initialContentSize.width) / 2 - self.kBorderCorrectionValue,
            y: (height - toolbarSize - self.initialContentSize.height) / 2 - self.kBorderCorrectionValue,
            width: self.initialContentSize.width + self.kBorderCorrectionValue * 2,
            height: self.initialContentSize.height + self.kBorderCorrectionValue * 2)
    }

    fileprivate func calculateAnchorBorder(_ anchorPoint: CGPoint) -> CGPoint {
        let positions: [CGPoint] = self.allPositions()
        var closest: CGFloat = CGFloat.greatestFiniteMagnitude
        var anchor: CGPoint = CGPoint.zero
        for position in positions {
            let xDist: CGFloat = position.x - anchorPoint.x
            let yDist: CGFloat = position.y - anchorPoint.y
            let dist: CGFloat = sqrt(xDist * xDist + yDist * yDist)
            closest = min(dist, closest)
            anchor = closest == dist ? position : anchor
        }
        return anchor
    }

    fileprivate func allPositions() -> [CGPoint] {
        return [
            CGPoint(x: 0, y: 0),
            CGPoint(x: self.cropBorderView.bounds.size.width / 2, y: 0),
            CGPoint(x: self.cropBorderView.bounds.size.width, y: 0),
            CGPoint(x: self.cropBorderView.bounds.size.width, y: self.cropBorderView.bounds.size.height / 2),
            CGPoint(x: self.cropBorderView.bounds.size.width, y: self.cropBorderView.bounds.size.height),
            CGPoint(x: self.cropBorderView.bounds.size.width / 2, y: self.cropBorderView.bounds.size.height),
            CGPoint(x: 0, y: self.cropBorderView.bounds.size.height),
            CGPoint(x: 0, y: self.cropBorderView.bounds.size.height / 2)
        ]
    }

    fileprivate func resizeWithTouchPoint(_ point: CGPoint) {
        guard let superview: UIView = self.superview else { return }
        let border: CGFloat = self.kBorderCorrectionValue * 2
        var pointX: CGFloat = point.x < border ? border : point.x
        var pointY: CGFloat = point.y < border ? border : point.y
        pointX = pointX > superview.bounds.size.width - border ? superview.bounds.size.width - border : pointX
        pointY = pointY > superview.bounds.size.height - border ? superview.bounds.size.height - border : pointY
        let heightChange: CGFloat = (pointY - self.startPoint.y) * self.resizeMultiplyer.heightMultiplyer
        let widthChange: CGFloat = (self.startPoint.x - pointX) * self.resizeMultiplyer.widthMultiplyer
        let xChange: CGFloat = -1 * widthChange * self.resizeMultiplyer.xMultiplyer
        let yChange: CGFloat = -1 * heightChange * self.resizeMultiplyer.yMultiplyer
        var newFrame: CGRect = CGRect(
            x: self.cropBorderView.frame.origin.x + xChange,
            y: self.cropBorderView.frame.origin.y + yChange,
            width: self.cropBorderView.frame.size.width + widthChange,
            height: self.cropBorderView.frame.size.height + heightChange)
        newFrame = self.preventBorderFrameFromGettingTooSmallOrTooBig(newFrame)
        self.resetFrame(to: newFrame)
        self.startPoint = CGPoint(x: pointX, y: pointY)
    }

    fileprivate func preventBorderFrameFromGettingTooSmallOrTooBig(_ frame: CGRect) -> CGRect {
        guard let superview: UIView = self.superview else { return frame }
        let toolbarSize: CGFloat = 54.0 + UIView.safeArea.bottom
        var newFrame = frame
        if newFrame.size.width < 64 {
            newFrame.size.width = self.cropBorderView.frame.size.width
            newFrame.origin.x = self.cropBorderView.frame.origin.x
        }
        if newFrame.size.height < 64 {
            newFrame.size.height = self.cropBorderView.frame.size.height
            newFrame.origin.y = self.cropBorderView.frame.origin.y
        }
        if newFrame.origin.x < 0 {
            newFrame.size.width = self.cropBorderView.frame.size.width +
                (self.cropBorderView.frame.origin.x - superview.bounds.origin.x)
            newFrame.origin.x = 0
        }
        if newFrame.origin.y < 0 {
            newFrame.size.height = self.cropBorderView.frame.size.height +
                (self.cropBorderView.frame.origin.y - superview.bounds.origin.y)
            newFrame.origin.y = 0
        }
        if newFrame.size.width + newFrame.origin.x > self.frame.size.width {
            newFrame.size.width = self.frame.size.width - self.cropBorderView.frame.origin.x
        }
        if newFrame.size.height + newFrame.origin.y > self.frame.size.height - toolbarSize {
            newFrame.size.height = self.frame.size.height -
                self.cropBorderView.frame.origin.y - toolbarSize
        }
        return newFrame
    }

    fileprivate func resetFrame(to frame: CGRect) {
        self.cropBorderView.frame = frame
        self.contentView.frame = frame.insetBy(dx: self.kBorderCorrectionValue, dy: self.kBorderCorrectionValue)
        self.cropSize = self.contentView.frame.size
        self.setNeedsDisplay()
        self.cropBorderView.setNeedsDisplay()
    }

    fileprivate func fillMultiplyer() {
        self.resizeMultiplyer.heightMultiplyer = self.anchor.y == 0 ?
            -1 : self.anchor.y == self.cropBorderView.bounds.size.height ? 1 : 0
        self.resizeMultiplyer.widthMultiplyer = self.anchor.x == 0 ?
            1 : self.anchor.x == self.cropBorderView.bounds.size.width ? -1 : 0
        self.resizeMultiplyer.xMultiplyer = self.anchor.x == 0 ? 1 : 0
        self.resizeMultiplyer.yMultiplyer = self.anchor.y == 0 ? 1 : 0
    }
}
