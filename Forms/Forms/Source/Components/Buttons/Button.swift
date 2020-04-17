//
//  Button.swift
//  Forms
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import UIKit

// MARK: State
public extension Button {
    enum StateType {
        case active
        case selected
        case disabled
    }
    
    class State<T> {
        var active: T
        var selected: T
        var disabled: T
        
        init(_ value: T) {
            self.active = value
            self.selected = value
            self.disabled = value
        }
        
        init(active: T, selected: T, disabled: T) {
            self.active = active
            self.selected = selected
            self.disabled = disabled
        }
        
        func value(for state: StateType) -> T {
            switch state {
            case .active: return self.active
            case .selected: return self.selected
            case .disabled: return self.disabled
            }
        }
    }
}

// MARK: Button
open class Button: FormComponent, Clickable {
    public let backgroundView = UIView()
        .with(isUserInteractionEnabled: true)
    public let titleLabel = UILabel()
    public let gestureRecognizer = UILongPressGestureRecognizer()
    
    open var animationTime: TimeInterval = 0.2
    open var backgroundColors: State<UIColor?> = State<UIColor?>(UIColor.systemBackground) {
        didSet { self.updateState() }
    }
    open var edgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateEdgeInset() }
    }
    open var height: CGFloat = UITableView.automaticDimension
    open var isEnabled: Bool {
        get { return self.gestureRecognizer.isEnabled }
        set { newValue ? self.enable(animated: false) : self.disable(animated: false) }
    }
    open var maxHeight: CGFloat = CGFloat.greatestConstraintConstant {
        didSet { self.updateMaxHeight() }
    }
    open var minHeight: CGFloat = 0.0 {
        didSet { self.updateMinHeight() }
    }
    open var title: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    open var titleColors: State<UIColor?> = State<UIColor?>(UIColor.label) {
        didSet { self.updateState() }
    }
    open var titleEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateTitleEdgeInset() }
    }
    open var titleFonts: State<UIFont> = State<UIFont>(UIFont.systemFont(ofSize: 14)) {
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
    
    private (set) var state: StateType = StateType.active
    
    override open func setupView() {
        self.setupComponentView()
        self.setupBackgroundView()
        self.setupTitleLabel()
        self.updateState()
        super.setupView()
    } 
    
    override open func setupActions() {
        super.setupActions()
        self.gestureRecognizer.minimumPressDuration = 0.0
        self.gestureRecognizer.addTarget(self, action: #selector(handleGesture))
        self.backgroundView.addGestureRecognizer(self.gestureRecognizer)
    }
    
    override open func enable(animated: Bool) {
        guard !self.gestureRecognizer.isEnabled else { return }
        self.gestureRecognizer.isEnabled = true
        self.setState(.active, animated: animated)
    }
    
    override open func disable(animated: Bool) {
        guard self.gestureRecognizer.isEnabled else { return }
        self.gestureRecognizer.isEnabled = false
        self.setState(.disabled, animated: animated)
    }
    
    override open func componentHeight() -> CGFloat {
        return self.height
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
    
    private func setupComponentView() {
        self.anchors([
            Anchor.to(self).height(self.minHeight).greaterThanOrEqual,
            Anchor.to(self).height(self.maxHeight).lessThanOrEqual
        ])
    }
    
    private func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    private func setupTitleLabel() {
        self.titleLabel.frame = self.backgroundView.bounds
        self.backgroundView.addSubview(self.titleLabel, with: [
            Anchor.to(self.backgroundView).fill
        ])
    }
    
    private func updateEdgeInset() {
        let edgeInset: UIEdgeInsets = self.edgeInset
        self.backgroundView.frame = self.bounds.with(inset: edgeInset)
        self.backgroundView.constraint(to: self, position: .top)?.constant = edgeInset.top
        self.backgroundView.constraint(to: self, position: .bottom)?.constant = -edgeInset.bottom
        self.backgroundView.constraint(to: self, position: .leading)?.constant = edgeInset.leading
        self.backgroundView.constraint(to: self, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    private func updateTitleEdgeInset() {
        let edgeInset: UIEdgeInsets = self.titleEdgeInset
        self.titleLabel.frame = self.backgroundView.bounds.with(inset: edgeInset)
        self.titleLabel.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.titleLabel.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.titleLabel.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.titleLabel.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    private func updateMaxHeight() {
        let maxHeight: CGFloat = self.maxHeight
        self.constraint(position: .height, relation: .lessThanOrEqual)?.constant = maxHeight
    }
    
    private func updateMinHeight() {
        let minHeight: CGFloat = self.minHeight
        self.constraint(position: .height, relation: .greaterThanOrEqual)?.constant = minHeight
    }
    
    private func updateState() {
        switch self.state {
        case .active: self.setState(.active, animated: false, force: true)
        case .selected: self.setState(.selected, animated: false, force: true)
        case .disabled: self.setState(.disabled, animated: false, force: true)
        }
    }
    
    private func setState(_ state: StateType,
                          animated: Bool,
                          force: Bool = false) {
        guard self.state != state || force else { return }
        self.animation(animated, duration: self.animationTime) {
            self.backgroundView.backgroundColor = self.backgroundColors.value(for: state)
            self.titleLabel.textColor = self.titleColors.value(for: state)
            self.titleLabel.font = self.titleFonts.value(for: state)
        }
        self.state = state
    }
}

// MARK: Builder
public extension Button {
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
    func with(edgeInset: UIEdgeInsets) -> Self {
        self.edgeInset = edgeInset
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
    func with(maxHeight: CGFloat) -> Self {
        self.maxHeight = maxHeight
        return self
    }
    func with(minHeight: CGFloat) -> Self {
        self.minHeight = minHeight
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
    func with(titleEdgeInset: UIEdgeInsets) -> Self {
        self.titleEdgeInset = titleEdgeInset
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
