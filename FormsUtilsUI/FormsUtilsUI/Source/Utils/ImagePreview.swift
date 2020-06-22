//
//  ImagePreview.swift
//  FormsUtils
//
//  Created by Konrad on 6/25/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UIImageView
public extension UIImageView {
    private static var gestureKey: UInt8 = 0
    private static var isPreviewEnabledKey: UInt8 = 0
    private static var previewViewKey: UInt8 = 0
    private static var initFrameKey: UInt8 = 0
    
    var isPreviewable: Bool {
        get { return (objc_getAssociatedObject(self, &Self.isPreviewEnabledKey) as? Bool) ?? false }
        set {
            objc_setAssociatedObject(self, &Self.isPreviewEnabledKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.updateIsPreviewable()
        }
    }
    var isPreviewEnabled: Bool {
        get { return (objc_getAssociatedObject(self, &Self.isPreviewEnabledKey) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, &Self.isPreviewEnabledKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    private var gesture: UITapGestureRecognizer? {
        get { return objc_getAssociatedObject(self, &Self.gestureKey) as? UITapGestureRecognizer }
        set { objc_setAssociatedObject(self, &Self.gestureKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    private var previewView: UIView? {
        get { return objc_getAssociatedObject(self, &Self.previewViewKey) as? UIView }
        set { objc_setAssociatedObject(self, &Self.previewViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    private var initFrame: CGRect? {
        get { return objc_getAssociatedObject(self, &Self.initFrameKey) as? CGRect }
        set { objc_setAssociatedObject(self, &Self.initFrameKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func updateIsPreviewable() {
        if let gesture = self.gesture {
            self.removeGestureRecognizer(gesture)
            self.gesture = nil
        } else {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(openFullScreen))
            self.addGestureRecognizer(gesture)
            self.isUserInteractionEnabled = true
            self.gesture = gesture
        }
    }
    
    @objc
    private func openFullScreen() {
        guard self.isPreviewEnabled else { return }
        guard let window: UIWindow = self.window else { return }
        let view = UIView(frame: UIScreen.main.bounds)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeFullScreen)))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panFullScreen)))
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.clear
        let background = UIView(frame: UIScreen.main.bounds)
        background.tag = 100
        background.alpha = 0
        background.backgroundColor = UIColor.black
        let image: UIImageView = UIImageView(image: self.image)
        let frame: CGRect = self.convert(self.bounds, to: window)
        image.tag = 101
        image.frame = frame
        image.contentMode = .scaleAspectFit
        view.addSubview(background)
        view.addSubview(image)
        window.addSubview(view)
        self.isHidden = true
        self.previewView = view
        self.initFrame = frame
        
        UIView.animate(withDuration: 0.3) {
            background.alpha = 1
            image.frame = window.frame
            image.center = window.center
        }
    }
    
    @objc
    private func closeFullScreen() {
        guard let background: UIView = self.previewView?.viewWithTag(100) else { return }
        guard let image: UIImageView = self.previewView?.viewWithTag(101) as? UIImageView else { return }
        UIView.animate(
            withDuration: 0.3,
            animations: {
                image.frame = self.initFrame ?? CGRect.zero
                background.alpha = 0
        }, completion: { _ in
            self.isHidden = false
            self.previewView?.removeFromSuperview()
            self.previewView = nil
            self.initFrame = nil
        })
    }
    
    @objc
    private func panFullScreen(_ recognizer: UIPanGestureRecognizer) {
        guard let view: UIView = self.previewView else { return }
        guard let background: UIView = view.viewWithTag(100) else { return }
        guard let image: UIImageView = view.viewWithTag(101) as? UIImageView else { return }
        let translation: CGPoint = recognizer.translation(in: view)
        var progressX: CGFloat = abs(translation.x) / (view.frame.width / 2)
        var progressY: CGFloat = abs(translation.y) / (view.frame.height / 2)
        
        if recognizer.state != .ended && recognizer.state != .cancelled {
            background.alpha = 1 - max(progressX, progressY)
            let center: CGPoint = CGPoint(
                x: view.center.x + translation.x,
                y: view.center.y + translation.y)
            UIView.animate(withDuration: 0.3) {
                    image.center = center
            }
        } else {
            let velocity = recognizer.velocity(in: self)
            progressX = (progressX + (velocity.x / 2_000.0)).match(in: 0..<1)
            progressY = (progressY + (velocity.y / 2_000.0)).match(in: 0..<1)
            if max(progressX, progressY) >= 0.5 {
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        image.frame = self.initFrame ?? CGRect.zero
                        background.alpha = 0
                }, completion: { _ in
                    self.isHidden = false
                    self.previewView?.removeFromSuperview()
                    self.previewView = nil
                    self.initFrame = nil
                })
            } else {
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        image.frame = view.frame
                        background.alpha = 1
                        image.center = view.center
                })
            }
        }
    }
}

// MARK: Builder
public extension UIImageView {
    func with(isPreviewable: Bool) -> Self {
        self.isPreviewable = isPreviewable
        return self
    }
    func with(isPreviewEnabled: Bool) -> Self {
        self.isPreviewEnabled = isPreviewEnabled
        return self
    }
}
