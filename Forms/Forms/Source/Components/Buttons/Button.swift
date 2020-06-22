//
//  Button.swift
//  Forms
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import UIKit

// MARK: State
public extension Button {
    struct State<T>: FormsComponentStateActiveSelectedDisabledLoading {
        public var active: T!
        public var selected: T!
        public var disabled: T!
        public var loading: T!
        
        public init() { }
    }
}

// MARK: Button
open class Button: FormsComponent, Clickable, FormsComponentWithLoading, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
        .with(isUserInteractionEnabled: true)
        .with(clipsToBounds: true)
    public let borderView = UnShimmerableView()
    public let titleLabel = UnShimmerableLabel()
    public lazy var loaderView = UIActivityIndicatorView()
        .with(hidesWhenStopped: true)
    public let gestureRecognizer = UILongPressGestureRecognizer()
    
    open var animationTime: TimeInterval = 0.1
    open var backgroundColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryLight) {
        didSet { self.updateState() }
    }
    open var borderColors: State<UIColor?> = State<UIColor?>(UIColor.clear) {
        didSet { self.updateState() }
    }
    open var borderWidth: CGFloat {
        get { return self.borderView.layer.borderWidth }
        set { self.borderView.layer.borderWidth = newValue }
    }
    open var cornerRadius: CGFloat {
        get { return self.backgroundView.layer.cornerRadius }
        set {
            self.backgroundView.layer.cornerRadius = newValue
            self.borderView.layer.cornerRadius = newValue
        }
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
    open var title: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    open var titleColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryDark) {
        didSet { self.updateState() }
    }
    open var titleFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 14)) {
        didSet { self.updateState() }
    }
    open var titleNumberOfLines: Int {
        get { return self.titleLabel.numberOfLines }
        set { self.titleLabel.numberOfLines = newValue }
    }
    open var titleTextAlignment: NSTextAlignment {
        get { return self.titleLabel.textAlignment }
        set { self.titleLabel.textAlignment = newValue }
    }
    
    public var onClick: (() -> Void)? = nil
    
    private (set) var state: FormsComponentStateType = .active
    
    override open func setupView() {
        self.setupComponentView()
        self.setupBackgroundView()
        self.setupBorderView()
        self.setupTitleLabel()
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
    
    open func setupBorderView() {
        self.borderView.frame = self.backgroundView.bounds
        self.backgroundView.addSubview(self.borderView, with: [
            Anchor.to(self.backgroundView).fill
        ])
    }
    
    open func setupTitleLabel() {
        self.titleLabel.frame = self.backgroundView.bounds
        self.backgroundView.addSubview(self.titleLabel, with: [
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
        self.titleLabel.frame = self.backgroundView.bounds.with(inset: edgeInset)
        self.titleLabel.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.titleLabel.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.titleLabel.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.titleLabel.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    open func updateGesture() {
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
        self.borderView.layer.borderColor = self.borderColors.value(for: state)?.cgColor
        self.titleLabel.textColor = self.titleColors.value(for: state)
        self.titleLabel.font = self.titleFonts.value(for: state)
        self.loaderView.color = self.titleColors.value(for: state)
    }
    
    open func addLoader(animated: Bool) {
        self.loaderView.startAnimating()
        self.loaderView.center = self.backgroundView.center
        self.backgroundView.addSubview(self.loaderView, with: [
            Anchor.to(self.backgroundView).center
        ])
        self.animation(
            animated,
            duration: self.animationTime * 3,
            animations: {
                self.titleLabel.alpha = 0
                self.loaderView.alpha = 1
        }, completion: { status in
            self.titleLabel.isHidden = status
        })
    }
    
    open func removeLoader(animated: Bool) {
        self.titleLabel.isHidden = false
        self.animation(
            animated,
            duration: self.animationTime * 3,
            animations: {
                self.titleLabel.alpha = 1
                self.loaderView.alpha = 0
        }, completion: { _ in
            self.loaderView.stopAnimating()
            self.loaderView.removeFromSuperview()
        })
    }
}

// MARK: Builder
public extension Button {
    func with(animationTime: TimeInterval) -> Self {
        self.animationTime = animationTime
        return self
    }
    @objc
    override func with(borderColor: UIColor?) -> Self {
        self.borderColors = State<UIColor?>(borderColor)
        return self
    }
    func with(borderColors: State<UIColor?>) -> Self {
        self.borderColors = borderColors
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
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    } 
    func with(title: String?) -> Self {
        self.title = title
        return self
    }
    func with(titleColor: UIColor?) -> Self {
        self.titleColors = State<UIColor?>(titleColor)
        return self
    }
    func with(titleColors: State<UIColor?>) -> Self {
        self.titleColors = titleColors
        return self
    }
    func with(titleFont: UIFont) -> Self {
        self.titleFonts = State<UIFont>(titleFont)
        return self
    }
    func with(titleFonts: State<UIFont>) -> Self {
        self.titleFonts = titleFonts
        return self
    }
    func with(titleNumberOfLines: Int) -> Self {
        self.titleNumberOfLines = titleNumberOfLines
        return self
    }
    func with(titleTextAlignment: NSTextAlignment) -> Self {
        self.titleTextAlignment = titleTextAlignment
        return self
    }
}
