//
//  ClickableView.swift
//  Forms
//
//  Created by Konrad on 6/24/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import UIKit

// MARK: State
public extension ClickableView {
    struct State<T>: FormsComponentStateActiveSelectedDisabledLoading {
        public var active: T!
        public var selected: T!
        public var disabled: T!
        public var loading: T!
        
        public init() { }
    }
}

// MARK: ClickableView
open class ClickableView: FormsComponent, Loadingable, Clickable, FormsComponentWithLoading, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UnShimmerableView()
        .with(width: 320, height: 40)
    public let contentView = UnShimmerableView()
        .with(width: 320, height: 40)
    public lazy var loaderView = UIActivityIndicatorView()
        .with(hidesWhenStopped: true)
    public let button = UIButton()
    
    open var animationTime: TimeInterval = 0.2
    open var backgroundColors: State<UIColor?> = State<UIColor?>(Theme.Colors.clear) {
        didSet { self.updateState() }
    }
    open var content: UIView? = nil {
        didSet { self.updateContent() }
    }
    open var height: CGFloat = UITableView.automaticDimension
    open var isEnabled: Bool = true {
        didSet { self.updateGesture() }
    }
    open var isLoading: Bool = false {
        didSet { self.updateGesture() }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    
    public var onClick: (() -> Void)? = nil
    
    private (set) var state: FormsComponentStateType = FormsComponentStateType.active
    
    override open func setupView() {
        self.setupComponentView()
        self.setupBackgroundView()
        self.setupContentView()
        self.updateState()
        super.setupView()
    }
    
    override open func enable(animated: Bool) {
        if !self.isEnabled {
            self.isEnabled = true
        }
        self.setState(.active, animated: animated)
    }
    
    override open func disable(animated: Bool) {
        if self.isEnabled {
            self.isEnabled = false
        }
        self.setState(.disabled, animated: animated)
    }
    
    open func startLoading(animated: Bool = true) {
        guard !self.isLoading else { return }
        self.isLoading = true
        self.setState(.loading, animated: animated)
        self.addLoader(animated: animated)
    }
    
    open func stopLoading(animated: Bool = true) {
        guard self.isLoading else { return }
        self.isLoading = false
        self.setState(.active, animated: animated)
        self.removeLoader(animated: animated)
    }
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
    
    open func setupComponentView() {
        self.anchors([
            Anchor.to(self).height(self.minHeight).greaterThanOrEqual,
            Anchor.to(self).height(self.maxHeight).lessThanOrEqual
        ])
    }
    
    override open func setupActions() {
        super.setupActions()
        self.button.isExclusiveTouch = true
        self.button.addTarget(self, action: #selector(handleTouchSelected), for: [.touchDown, .touchDragEnter])
        self.button.addTarget(self, action: #selector(handleTouchActive), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        self.button.addTarget(self, action: #selector(handleTouchClick), for: .touchUpInside)
    }
    
    @objc
    private func handleTouchSelected(sender: UIButton) {
        self.setState(.selected, animated: true)
    }
    
    @objc
    private func handleTouchActive(sender: UIButton) {
        self.setState(.active, animated: true)
    }
    
    @objc
    private func handleTouchClick(sender: UIButton) {
        self.setState(.active, animated: true)
        self.onClick?()
    }
    
    open func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    open func setupContentView() {
        self.contentView.frame = self.backgroundView.bounds
        self.backgroundView.addSubview(self.contentView, with: [
            Anchor.to(self.backgroundView).fill
        ])
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
        self.contentView.frame = self.backgroundView.bounds.with(inset: edgeInset)
        self.contentView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.contentView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.contentView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.contentView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    open func updateContent() {
        self.contentView.removeSubviews()
        guard let content: UIView = self.content else { return }
        content.frame = self.contentView.bounds
        self.contentView.addSubview(content, with: [
            Anchor.to(self.contentView).fill
        ])
        self.button.frame = self.contentView.bounds
        self.button.setContentCompressionResistancePriority(.veryLow, for: .vertical)
        self.contentView.addSubview(self.button, with: [
            Anchor.to(self.contentView).fill
        ])
    }
    
    public func updateGesture() {
        self.button.isEnabled = self.isEnabled && !self.isLoading
        if self.isEnabled && !self.isLoading {
            self.enable(animated: false)
        } else if !self.isEnabled && !self.isLoading {
            self.disable(animated: false)
        } else if self.isLoading {
            self.startLoading(animated: false)
        } else if !self.isLoading {
            self.stopLoading(animated: false)
        }
    }
    
    override public func updateState() {
        guard !self.isBatchUpdateInProgress else { return }
        self.setState(self.state, animated: false, force: true)
    }
    
    public func setState(_ state: FormsComponentStateType,
                         animated: Bool,
                         force: Bool = false) {
        guard self.state != state || force else { return }
        self.animation(animated, duration: self.animationTime) {
            self.setStateAnimation(state)
        }
        self.state = state
    }
    
    open func setStateAnimation(_ state: FormsComponentStateType) {
        self.backgroundView.backgroundColor = self.backgroundColors.value(for: state)
    }
    
    open func addLoader(animated: Bool,
                        animations: (() -> Void)? = nil,
                        completion: ((Bool) -> Void)? = nil) {
        self.loaderView.startAnimating()
        self.loaderView.center = self.backgroundView.center
        self.backgroundView.addSubview(self.loaderView, with: [
            Anchor.to(self.backgroundView).center
        ])
        self.animation(
            animated,
            duration: self.animationTime * 3,
            animations: {
                animations?()
                self.loaderView.alpha = 1
        }, completion: { (status) in
            completion?(status)
        })
    }
    
    open func removeLoader(animated: Bool,
                           animations: (() -> Void)? = nil,
                           completion: ((Bool) -> Void)? = nil) {
        self.animation(
            animated,
            duration: self.animationTime * 3,
            animations: {
                animations?()
                self.loaderView.alpha = 0
        }, completion: { (status) in
            completion?(status)
            self.loaderView.stopAnimating()
            self.loaderView.removeFromSuperview()
        })
    }
}

// MARK: Builder
public extension ClickableView {
    func with(animationTime: TimeInterval) -> Self {
        self.animationTime = animationTime
        return self
    }
    @objc
    override func with(backgroundColor: UIColor?) -> Self {
        self.backgroundColors = State<UIColor?>(backgroundColor)
        return self
    }
    func with(backgroundColors: State<UIColor?>) -> Self {
        self.backgroundColors = backgroundColors
        return self
    }
    func with(content: UIView) -> Self {
        self.content = content
        return self
    }
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }
}
