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
    enum StateType: Int, CaseIterable {
        case active
        case selected
        case disabled
        case disabledSelected
        
        var controlState: UIControl.State {
            switch self {
            case .active: return .normal
            case .selected: return .selected
            case .disabled: return .disabled
            case .disabledSelected: return .selected
            }
        }
        var isEnabled: Bool {
            switch self {
            case .active: return true
            case .selected: return true
            case .disabled: return false
            case .disabledSelected: return false
            }
        }
    }
    
    struct State<T> {
        let active: T
        let selected: T
        let disabled: T
        let disabledSelected: T
        
        public init(_ value: T) {
            self.active = value
            self.selected = value
            self.disabled = value
            self.disabledSelected = value
        }
        
        public init(active: T, selected: T) {
            self.active = active
            self.selected = selected
            self.disabled = active
            self.disabledSelected = selected
        }
        
        public init(active: T, selected: T, disabled: T) {
            self.active = active
            self.selected = selected
            self.disabled = disabled
            self.disabledSelected = disabled
        }
        
        public init(active: T, selected: T, disabled: T, disabledSelected: T) {
            self.active = active
            self.selected = selected
            self.disabled = disabled
            self.disabledSelected = disabledSelected
        }
        
        func value(for state: StateType) -> T {
            switch state {
            case .active: return self.active
            case .selected: return self.selected
            case .disabled: return self.disabled
            case .disabledSelected: return self.disabledSelected
            }
        }
    }
}

// MARK: SegmentItem
public protocol SegmentItem {
    var rawValue: Int { get }
    var title: String { get }
}

// MARK: SegmentControl
open class SegmentControl: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    private let backgroundView = UIView()
        .with(width: 320, height: 40)
    private let segmentControl = UISegmentedControl()
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
    
    private (set) var state: StateType = StateType.active
    
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
        guard !self.isUserInteractionEnabled else { return }
        self.isUserInteractionEnabled = true
        self.setState(.active, animated: animated)
    }
    
    override open func disable(animated: Bool) {
        guard self.isUserInteractionEnabled else { return }
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
        self.segmentControl.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.segmentControl.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.segmentControl.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.segmentControl.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
     
    private func updateState(animated: Bool) {
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
    
    private func updateState() {
        self.updateSegmentState()
        switch self.state {
        case .active: self.setState(.active, animated: false, force: true)
        case .selected: self.setState(.selected, animated: false, force: true)
        case .disabled: self.setState(.disabled, animated: false, force: true)
        case .disabledSelected: self.setState(.disabledSelected, animated: false, force: true)
        }
    }
    
    private func setState(_ state: StateType,
                          animated: Bool,
                          force: Bool = false) {
        guard self.state != state || force else { return }
        self.animation(animated, duration: self.animationTime) {
            self.updateSegmentSelection(state)
            self.backgroundView.backgroundColor = self.backgroundColors.value(for: state)
            if #available(iOS 13.0, *) {
                self.segmentControl.selectedSegmentTintColor = self.tintColors.value(for: state)
            }
        }
        self.state = state
    }
    
    private func updateSegmentState() {
        self.segmentControl.tintColor = self.textColors.value(for: .active)
        for state in StateType.allCases {
            self.segmentControl.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: self.textColors.value(for: state),
                NSAttributedString.Key.font: self.textFonts.value(for: state)
            ], for: state.controlState)
        }
    }
    
    private func updateSegmentSelection(_ state: StateType) {
        for (i, item) in self.items.enumerated() {
            let isEnabled: Bool = !self.disabled.contains(where: { $0.rawValue == item.rawValue }) && state.isEnabled
            self.segmentControl.setEnabled(isEnabled, forSegmentAt: i)
        }
    }
}

// MARK: Switch
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
