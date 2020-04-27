//
//  ActivityIndicator.swift
//  Forms
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import UIKit

// MARK: ActivityIndicator
open class ActivityIndicator: FormComponent, FormComponentWithMarginEdgeInset, FormComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
    public let activityIndicator = UIActivityIndicatorView()
        .with(isUserInteractionEnabled: true)
    
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    open var color: UIColor? {
        get { return self.activityIndicator.color }
        set { self.activityIndicator.color = newValue }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var height: CGFloat = UITableView.automaticDimension
    open var isAnimating: Bool {
        get { return self.activityIndicator.isAnimating }
        set { newValue ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var style: UIActivityIndicatorView.Style {
        get { return self.activityIndicator.style }
        set { self.activityIndicator.style = newValue }
    }
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupActivityIndicator()
        super.setupView()
    }
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
    
    private func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    private func setupActivityIndicator() {
        self.activityIndicator.frame = self.bounds
        self.backgroundView.addSubview(self.activityIndicator, with: [
            Anchor.to(self.backgroundView).fill
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
        self.activityIndicator.frame = self.bounds.with(inset: edgeInset)
        self.activityIndicator.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.activityIndicator.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.activityIndicator.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.activityIndicator.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
}

// MARK: Builder
public extension ActivityIndicator {
    func with(color: UIColor) -> Self {
        self.color = color
        return self
    }
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(isAnimating: Bool) -> Self {
        self.isAnimating = isAnimating
        return self
    }
    func with(style: UIActivityIndicatorView.Style) -> Self {
        self.style = style
        return self
    }
}
