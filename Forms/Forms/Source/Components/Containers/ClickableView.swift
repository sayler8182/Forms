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
    struct State<T>: FormsComponentStateActiveSelectedDisabled {
        public var active: T!
        public var selected: T!
        public var disabled: T!
        
        public init() { }
    }
}

// MARK: ClickableView
open class ClickableView: FormsComponent, Clickable, FormsComponentWithLoading, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UnShimmerableView()
        .with(isUserInteractionEnabled: true)
    public let contentView = UnShimmerableView()
    public let gestureRecognizer = UILongPressGestureRecognizer()
    
    open var animationTime: TimeInterval = 0.2
    open var backgroundColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryLight) {
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
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
    
    override open func setupActions() {
        super.setupActions()
        self.gestureRecognizer.minimumPressDuration = 0.0
        self.gestureRecognizer.addTarget(self, action: #selector(handleGesture))
        self.backgroundView.addGestureRecognizer(self.gestureRecognizer)
    }
    
    @objc
    private func handleGesture(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.setState(.selected, animated: true)
        case .changed:
            let point: CGPoint = recognizer.location(in: self.backgroundView)
            if self.backgroundView.bounds.contains(point) {
                self.setState(.selected, animated: true)
            } else {
                self.setState(.active, animated: true)
            }
        case .ended:
            self.setState(.active, animated: true)
            let point: CGPoint = recognizer.location(in: self.backgroundView)
            if self.backgroundView.bounds.contains(point) {
                self.onClick?()
            }
        default:
            self.setState(.active, animated: true)
        }
    }
    
    open func setupComponentView() {
        self.anchors([
            Anchor.to(self).height(self.minHeight).greaterThanOrEqual,
            Anchor.to(self).height(self.maxHeight).lessThanOrEqual
        ])
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
    }
    
    public func updateGesture() {
        self.gestureRecognizer.isEnabled = self.isEnabled && !self.isLoading
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
    
    public func updateState() {
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
