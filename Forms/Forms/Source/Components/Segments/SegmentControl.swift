//
//  SegmentControl.swift
//  Forms
//
//  Created by Konrad on 6/10/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import UIKit

// MARK: State
public extension SegmentControl {
    struct State<T>: FormsComponentStateActiveSelectedDisabledDisabledSelected {
        public var active: T!
        public var selected: T!
        public var disabled: T!
        public var disabledSelected: T!
        
        public init() { }
    }
}

// MARK: SegmentItem
public protocol SegmentItem {
    var rawValue: Int { get }
    var title: String { get }
}

// MARK: SegmentControl
open class SegmentControl: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
        .with(width: 320, height: 40)
    public let segmentControl = UISegmentedControl()
        .with(width: 320, height: 40)
    
    open var animationTime: TimeInterval = 0.2
    open var backgroundColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryLight) {
        didSet { self.updateState() }
    }
    open var disabled: [SegmentItem] = [] {
        didSet { self.updateItems() }
    }
    open var isEnabled: Bool {
        get { return self.isUserInteractionEnabled }
        set { newValue ? self.enable(animated: false) : self.disable(animated: false) }
    }
    open var items: [SegmentItem] = [] {
        didSet { self.updateItems() }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    private var _selected: SegmentItem? = nil {
        didSet { self.updateState(animated: false) }
    }
    open var selected: SegmentItem? {
        get { self._selected }
        set {
            self._selected = newValue
            self.segmentControl.selectedSegmentIndex = newValue?.rawValue ?? -1
        }
    }
    open var textColors: State<UIColor> = State<UIColor>(Theme.Colors.primaryDark) {
        didSet { self.updateState() }
    }
    open var textFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 12)) {
        didSet { self.updateState() }
    }
    open var tintColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryLight) {
        didSet { self.updateState() }
    }
    
    public var onValueChanged: ((SegmentItem?) -> Void)? = nil
    
    private (set) var state: FormsComponentStateType = .active
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupSegmentControl()
        super.setupView()
    }
    
    override open func setupActions() {
        super.setupActions()
        self.segmentControl.addTarget(self, action: #selector(handleOnValueChanged), for: .valueChanged)
    }
    
    @objc
    private func handleOnValueChanged(_ sender: UISegmentedControl) {
        self._selected = self.items[safe: sender.selectedSegmentIndex]
        self.onValueChanged?(self.selected)
    }
    
    override open func enable(animated: Bool) {
        self.isUserInteractionEnabled = true
        self.setState(.active, animated: animated)
    }
    
    override open func disable(animated: Bool) {
        self.isUserInteractionEnabled = false
        if self.selected.isNil {
            self.setState(.disabled, animated: animated)
        } else {
            self.setState(.disabledSelected, animated: animated)
        }
    }
    
    open func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    open func setupSegmentControl() {
        self.backgroundView.addSubview(self.segmentControl, with: [
            Anchor.to(self.backgroundView).fill
        ])
    }
    
    private func updateItems() {
        self.segmentControl.removeAllSegments()
        for (i, item) in self.items.enumerated() {
            self.segmentControl.insertSegment(
                withTitle: item.title,
                at: i,
                animated: false)
        }
        self.updateSegmentSelection(self.state)
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
        self.segmentControl.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.segmentControl.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.segmentControl.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.segmentControl.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    public func updateState(animated: Bool) {
        if !self.isEnabled && self.selected.isNil {
            self.setState(.disabled, animated: animated)
        } else if !self.isEnabled && self.selected.isNotNil {
            self.setState(.disabledSelected, animated: animated)
        } else if self.selected.isNotNil {
            self.setState(.selected, animated: animated)
        } else {
            self.setState(.active, animated: animated)
        }
    }
    
    public func updateState() {
        self.updateSegmentState()
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
        self.updateSegmentSelection(state)
        self.backgroundView.backgroundColor = self.backgroundColors.value(for: state)
        if #available(iOS 13.0, *) {
            self.segmentControl.selectedSegmentTintColor = self.tintColors.value(for: state)
        }
    }
    
    private func updateSegmentState() {
        self.segmentControl.tintColor = self.textColors.value(for: .active)
        for state: FormsComponentStateType in [.active, .selected, .disabled, .disabledSelected] {
            self.segmentControl.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: self.textColors.value(for: state),
                NSAttributedString.Key.font: self.textFonts.value(for: state)
            ], for: state.controlState)
        }
    }
    
    private func updateSegmentSelection(_ state: FormsComponentStateType) {
        for (i, item) in self.items.enumerated() {
            let isEnabled: Bool = !self.disabled.contains(where: { $0.rawValue == item.rawValue }) && state.isEnabled
            self.segmentControl.setEnabled(isEnabled, forSegmentAt: i)
        }
    }
}

// MARK: Builder
public extension SegmentControl {
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
    func with(disabled: [SegmentItem]) -> Self {
        self.disabled = disabled
        return self
    }
    func with(isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }
    func with(items: [SegmentItem]) -> Self {
        self.items = items
        return self
    }
    func with(selected: SegmentItem?) -> Self {
        self.selected = selected
        return self
    }
    func with(textColor: UIColor) -> Self {
        self.textColors = State<UIColor>(textColor)
        return self
    }
    func with(textColors: State<UIColor>) -> Self {
        self.textColors = textColors
        return self
    }
    func with(textFont: UIFont) -> Self {
        self.textFonts = State<UIFont>(textFont)
        return self
    }
    func with(textFonts: State<UIFont>) -> Self {
        self.textFonts = textFonts
        return self
    }
    func with(tintColor: UIColor?) -> Self {
        self.tintColors = State<UIColor?>(tintColor)
        return self
    }
    func with(tintColors: State<UIColor?>) -> Self {
        self.tintColors = tintColors
        return self
    }
}
