//
//  ProgressBar.swift
//  Forms
//
//  Created by Konrad on 5/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import UIKit

// MARK: ProgressBar
open class ProgressBar: FormsComponent, FormsComponentWithProgress, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    private let backgroundView = UIView()
    private let primaryView = UIView()
    private let secondaryView = UIView()
    
    private let primaryHeightAnchor = AnchorConnection()
    
    open var animationTime: TimeInterval = 0.2
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    open var height: CGFloat = 4.0 {
        didSet { self.primaryHeightAnchor.constant = self.height }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var primaryColor: UIColor? {
        get { return self.primaryView.backgroundColor }
        set { self.primaryView.backgroundColor = newValue }
    }
    open var progress: CGFloat = 0 {
        didSet { self.setProgress(self.progress, animated: false) }
    }
    open var secondaryColor: UIColor? {
        get { return self.secondaryView.backgroundColor }
        set { self.secondaryView.backgroundColor = newValue }
    }
    
    override public func setupView() {
        self.setupBackgroundView()
        self.setupPrimaryView()
        self.setupSecondaryView()
        super.setupView()
    }
    
    override open func componentHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func setProgress(_ progress: CGFloat,
                            animated: Bool) {
        let progress: CGFloat = progress.match(in: 0..<1)
        self.animation(
            animated,
            duration: self.animationTime,
            animations: {
                self.secondaryView.constraint(to: self.primaryView, position: .width)?.isActive = false
                self.secondaryView.anchors([
                    Anchor.to(self.primaryView).width.multiplier(progress)
                ])
                self.primaryView.layoutIfNeeded()
        })
    }
    
    private func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    private func setupPrimaryView() {
        self.primaryView.frame = self.bounds
        self.backgroundView.addSubview(self.primaryView, with: [
            Anchor.to(self.backgroundView).fill,
            Anchor.to(self.primaryView).height(self.height).connect(self.primaryHeightAnchor)
        ])
    }
    
    private func setupSecondaryView() {
        self.secondaryView.frame = self.primaryView.frame
        self.secondaryView.frame.size.width = 0
        self.primaryView.addSubview(self.secondaryView, with: [
            Anchor.to(self.primaryView).vertical,
            Anchor.to(self.primaryView).leading,
            Anchor.to(self.primaryView).width.multiplier(0.0)
        ])
    }
    
    private func updateMarginEdgeInset() {
        let edgeInset: UIEdgeInsets = self.marginEdgeInset
        self.backgroundView.frame = self.bounds.with(inset: edgeInset)
        self.backgroundView.constraint(to: self, position: .top)?.constant = edgeInset.top
        self.backgroundView.constraint(to: self, position: .bottom)?.constant = -edgeInset.bottom
        self.backgroundView.constraint(to: self, position: .leading)?.constant = edgeInset.leading
        self.backgroundView.constraint(to: self, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    private func updatePaddingEdgeInset() {
        let edgeInset: UIEdgeInsets = self.paddingEdgeInset
        self.primaryView.frame = self.bounds.with(inset: edgeInset)
        self.primaryView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.primaryView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.primaryView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.primaryView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
}

// MARK: Builder
public extension ProgressBar {
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(primaryColor: UIColor) -> Self {
        self.primaryColor = primaryColor
        return self
    }
    func with(secondaryColor: UIColor) -> Self {
        self.secondaryColor = secondaryColor
        return self
    }
}
