//
//  ImageView.swift
//  Forms
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import UIKit

// MARK: ImageView
open class ImageView: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    private let backgroundView = UIView()
    private let imageView = UIImageView()
    
    private let imageHeightAnchor = AnchorConnection()
    private let imageWidthAnchor = AnchorConnection()
    
    open var aspectRatio: CGFloat? {
        didSet { self.updateAspectRatio() }
    }
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    open var color: UIColor? {
        get { return self.imageView.tintColor }
        set { self.imageView.tintColor = newValue }
    }
    override open var contentMode: UIView.ContentMode {
        get { return self.imageView.contentMode }
        set { self.imageView.contentMode = newValue }
    }
    open var height: CGFloat = UITableView.automaticDimension {
        didSet {
            self.updateHeight()
            self.updateAspectRatio()
        }
    }
    open var image: UIImage? {
        get { return self.imageView.image }
        set { self.imageView.image = newValue }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var width: CGFloat = UITableView.automaticDimension {
        didSet {
            self.updateWidth()
            self.updateAspectRatio()
        }
    }
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupImageView()
        super.setupView()
    }
    
    override open func componentHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    private func setupImageView() {
        self.imageView.clipsToBounds = true
        self.imageView.frame = self.bounds
        self.backgroundView.addSubview(self.imageView, with: [
            Anchor.to(self.backgroundView).fill,
            Anchor.to(self.imageView).height(0).connect(self.imageHeightAnchor).isActive(false),
            Anchor.to(self.imageView).width(0).connect(self.imageWidthAnchor).isActive(false)
        ])
    }
    
    private func updateAspectRatio() {
        guard let aspectRatio: CGFloat = self.aspectRatio else { return }
        if self.height != UITableView.automaticDimension {
            let imageWidthConstraint: NSLayoutConstraint? = self.imageWidthAnchor.constraint
            imageWidthConstraint?.isActive = true
            imageWidthConstraint?.constant = self.height * aspectRatio
        } else if self.width != UITableView.automaticDimension {
            let imageHeightConstraint: NSLayoutConstraint? = self.imageHeightAnchor.constraint
            imageHeightConstraint?.isActive = true
            imageHeightConstraint?.constant = self.width / aspectRatio
        }
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
        self.imageView.frame = self.bounds.with(inset: edgeInset)
        self.imageView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.imageView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.imageView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.imageView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    private func updateHeight() {
        let imageHeightConstraint: NSLayoutConstraint? = self.imageHeightAnchor.constraint
        if self.height == UITableView.automaticDimension {
            imageHeightConstraint?.isActive = false
            imageHeightConstraint?.constant = 0
        } else {
            imageHeightConstraint?.isActive = true
            imageHeightConstraint?.constant = self.height
        }
    }
    
    private func updateWidth() {
        let imageWidthConstraint: NSLayoutConstraint? = self.imageWidthAnchor.constraint
        if self.width == UITableView.automaticDimension {
            imageWidthConstraint?.isActive = false
            imageWidthConstraint?.constant = 0
        } else {
            imageWidthConstraint?.isActive = true
            imageWidthConstraint?.constant = self.width
        }
    }
}

// MARK: ImageView
public extension ImageView {
    func with(aspectRatio: CGFloat) -> Self {
        self.aspectRatio = aspectRatio
        return self
    }
    func with(color: UIColor?) -> Self {
        self.color = color
        return self
    }
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(image: UIImage?) -> Self {
        self.image = image
        return self
    }
    @objc
    override func with(width: CGFloat) -> Self {
        self.width = width
        return self
    }
}
