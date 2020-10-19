//
//  ImageView.swift
//  Forms
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsLogger
import FormsNetworking
import FormsNetworkingImage
import FormsUtils
import FormsUtilsUI
import UIKit

// MARK: ImageView
open class ImageView: FormsComponent, SVGView, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
    public let imageView = UIImageView()
    
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
    open var svgLayer: CAShapeLayer? {
        get { return self.imageView.svgLayer }
        set { self.imageView.svgLayer = newValue }
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
    
    override open func startShimmering(animated: Bool = true) {
        super.startShimmering(animated: animated)
        self.imageView.isPreviewEnabled = false
    }
    
    override open func stopShimmering(animated: Bool = true) {
        super.stopShimmering(animated: animated)
        self.imageView.isPreviewEnabled = true
    }
    
    open func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    open func setupImageView() {
        self.imageView.clipsToBounds = true
        self.imageView.frame = self.bounds
        self.backgroundView.addSubview(self.imageView, with: [
            Anchor.to(self.backgroundView).fill,
            Anchor.to(self.imageView).height(0).connect(self.imageHeightAnchor).isActive(false),
            Anchor.to(self.imageView).width(0).connect(self.imageWidthAnchor).isActive(false)
        ])
    }
    
    open func updateAspectRatio() {
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
    
    open func updateMarginEdgeInset() {
        let edgeInset: UIEdgeInsets = self.marginEdgeInset
        self.backgroundView.frame = self.bounds.with(inset: edgeInset)
        self.backgroundView.constraint(to: self, position: .top)?.constant = edgeInset.top
        self.backgroundView.constraint(to: self, position: .bottom)?.constant = -edgeInset.bottom
        self.backgroundView.constraint(to: self, position: .leading)?.constant = edgeInset.leading
        self.backgroundView.constraint(to: self, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    open func updatePaddingEdgeInset() {
        let edgeInset: UIEdgeInsets = self.paddingEdgeInset
        self.imageView.frame = self.bounds.with(inset: edgeInset)
        self.imageView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.imageView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.imageView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.imageView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    open func updateHeight() {
        let imageHeightConstraint: NSLayoutConstraint? = self.imageHeightAnchor.constraint
        if self.height == UITableView.automaticDimension {
            imageHeightConstraint?.isActive = false
            imageHeightConstraint?.constant = 0
        } else {
            imageHeightConstraint?.isActive = true
            imageHeightConstraint?.constant = self.height
        }
    }
    
    open func updateWidth() {
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

// MARK: ImagePreview
public extension ImageView {
    func with(isPreviewable: Bool) -> Self {
        self.imageView.isPreviewable = isPreviewable
        return self
    }
    func with(isPreviewEnabled: Bool) -> Self {
        self.imageView.isPreviewEnabled = isPreviewEnabled
        return self
    }
}

// MARK: NetworkImages
public extension ImageView {
    func isCached(request: NetworkImageRequest) -> Bool {
        return self.imageView.isCached(request)
    }
    
    func setImage(request: NetworkImageRequest,
                  logger: Logger? = nil,
                  cache: NetworkCache? = NetworkTmpCache(ttl: 60 * 60 * 24 * 30),
                  animated: Bool = true,
                  onProgress: NetworkImagesOnProgress? = nil,
                  onSuccess: NetworkImagesOnSuccess? = nil,
                  onError: NetworkImagesOnError? = nil,
                  onCompletion: NetworkImagesOnCompletion? = nil) {
        let isCached = request.isCached
        if !isCached && request.isStartAutoShimmer == true {
            self.startShimmering(animated: false)
        }
        self.imageView.setImage(
            request: request,
            logger: logger,
            cache: cache,
            onProgress: onProgress,
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: { [weak self] (image, error) in
                guard let `self` = self else { return }
                guard self.imageView.isValid(request) else { return }
                defer { onCompletion?(image, error) }
                let animated = animated && !isCached
                self.transition(
                    animated,
                    duration: 0.3,
                    animations: {
                        self.image = image?.image
                    })
                if request.isStopAutoShimmer == true {
                    self.stopShimmering(animated: animated)
                }
        })
    }
    
    func cancel() {
        self.imageView.stopShimmering(animated: false)
        self.imageView.cancel()
    }
}
