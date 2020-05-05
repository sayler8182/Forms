//
//  FormsModalController.swift
//  Forms
//
//  Created by Konrad on 5/5/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import UIKit

// MARK: FormsModalController
open class FormsModalController: FormsViewController {
    private let indicatorBackgroundView = UIView(width: 320, height: 16)
    private let indicatorView = UIView(width: 80, height: 4)
    private let contentView = UIView(width: 320, height: 64)
    private let panGestureRecognizer = UIPanGestureRecognizer()
    
    private var contentHeight: CGFloat = 80.0
    private let contentHeightAnchor = AnchorConnection()
    private var contentController: UIViewController? = nil
    private var overlayView: UIView? = nil
    
    open var backgroundColor: UIColor? = Theme.secondarySystemBackground {
        didSet { self.contentView.backgroundColor = self.backgroundColor }
    }
    open var cornerRadius: CGFloat = 8.0 {
        didSet { self.updateCornerRadius() }
    }
    open var height: CGFloat {
        get { return self.contentHeight }
        set {
            self.contentHeightAnchor.constraint?.constant = newValue
            self.contentHeight = newValue
        }
    }
    open var indicatorBackgroundColor: UIColor? = Theme.secondarySystemBackground {
        didSet { self.indicatorBackgroundView.backgroundColor = self.indicatorBackgroundColor }
    }
    open var indicatorColor: UIColor? = Theme.tertiarySystemBackground {
        didSet { self.indicatorView.backgroundColor = self.indicatorColor }
    }
    open var minHeight: CGFloat = 80.0
    open var maxHeight: CGFloat = 500.0
    
    public var onProgress: ((CGFloat) -> Void)? = nil
    
    public init(_ contentController: UIViewController) {
        self.contentController = contentController
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        self.contentController = nil
        super.init(coder: coder)
    }
    
    override open func setupView() {
        super.setupView()
        self.setupIndicatorView()
        self.setupContentView()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateCornerRadius()
    }
    
    override open func setupActions() {
        super.setupActions()
        self.view.isUserInteractionEnabled = true
        self.panGestureRecognizer.addTarget(self, action: #selector(handlePan))
        self.view.addGestureRecognizer(self.panGestureRecognizer)
    }
    
    open func add(to controller: UIViewController,
                  with overlayView: UIView? = nil) {
        self.overlayView = overlayView
        self.height = self.minHeight
        self.view.translatesAutoresizingMaskIntoConstraints = false
        if let overlayView: UIView = overlayView {
            overlayView.isHidden = true
            overlayView.alpha = 0
            controller.view.addSubview(overlayView, with: [
                Anchor.to(controller.view).fill
            ])
        }
        controller.addChild(self)
        controller.view.addSubview(self.view)
        self.view.anchors([
            Anchor.to(controller.view).bottom,
            Anchor.to(controller.view).horizontal
        ])
    }
    
    open func open(animated: Bool = true,
                   completion: ((Bool) -> Void)? = nil) {
    self.overlayView?.isHidden = false
      self.view.animation(
            animated,
            duration: 0.3,
            animations: {
                self.overlayView?.alpha = 1.0
                self.contentHeightAnchor.constraint?.constant = self.maxHeight
                self.parent?.view.layoutIfNeeded()
                self.onProgress?(1.0)
        }, completion: { (status) in
            self.contentHeight = self.maxHeight
            completion?(status)
        })
    }
    
    open func close(animated: Bool = true,
                    completion: ((Bool) -> Void)? = nil) {
        self.view.animation(
            animated,
            duration: 0.3,
            animations: {
                self.overlayView?.alpha = 0.0
                self.contentHeightAnchor.constraint?.constant = self.minHeight
                self.parent?.view.layoutIfNeeded()
                self.onProgress?(0.0)
        }, completion: { (status) in
            self.contentHeight = self.minHeight
            self.overlayView?.isHidden = true
            completion?(status)
        })
    }
    
    private func setupIndicatorView() {
        self.view.backgroundColor = UIColor.clear
        self.indicatorBackgroundView.backgroundColor = self.indicatorBackgroundColor
        self.view.addSubview(self.indicatorBackgroundView, with: [
            Anchor.to(self.view).top,
            Anchor.to(self.view).horizontal,
            Anchor.to(self.indicatorBackgroundView).height(16)
        ])
        self.indicatorView.backgroundColor = self.indicatorColor
        self.indicatorView.layer.cornerRadius = 2
        self.indicatorBackgroundView.addSubview(self.indicatorView, with: [
            Anchor.to(self.indicatorBackgroundView).center(80, 4)
        ])
    }
    
    private func setupContentView() {
        self.contentView.backgroundColor = self.backgroundColor
        self.view.addSubview(self.contentView, with: [
            Anchor.to(self.indicatorBackgroundView).topToBottom,
            Anchor.to(self.view).horizontal,
            Anchor.to(self.view).bottom,
            Anchor.to(self.contentView).height(self.height).connect(self.contentHeightAnchor)
        ])
    }
    
    @objc
    private func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let height: CGFloat = min(max(self.minHeight, self.contentHeight - translation.y), self.maxHeight)
        var progress: CGFloat = self.maxHeight != self.minHeight
            ? (height - self.minHeight) / (self.maxHeight - self.minHeight)
            : 1.0
        guard recognizer.state != .ended && recognizer.state != .cancelled else {
            let velocity = recognizer.velocity(in: self.view)
            progress = min(max(0, progress + (-velocity.y / 2_000.0)), 1.0)
            if progress >= 0.5 {
                self.open()
            } else {
                self.close()
            }
            return
        }
        
        self.overlayView?.isHidden = false
        self.overlayView?.alpha = progress
        self.view.animation(
            true,
            duration: 0.3,
            animations: {
                self.contentHeightAnchor.constraint?.constant = height
                self.onProgress?(progress)
        })
    }
    
    private func updateCornerRadius() {
        self.indicatorBackgroundView.setCornerRadius(corners: [.topLeft, .topRight], radius: self.cornerRadius)
    }
}

// MARK: UIViewController
public extension UIViewController {
    var modalController: FormsModalController? {
        return self.parent as? FormsModalController
    }
}
