//
//  Switch.swift
//  Forms
//
//  Created by Konrad on 6/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import UIKit

// MARK: State
public extension Switch {
    enum StateType {
        case active
        case selected
        case disabled
        case disabledSelected
    }
    
    struct State<T> {
        let active: T
        let selected: T
        let disabled: T
        let disabledSelected: T
        
        init(_ value: T) {
            self.active = value
            self.selected = value
            self.disabled = value
            self.disabledSelected = value
        }
        
        init(active: T, selected: T) {
            self.active = active
            self.selected = selected
            self.disabled = active
            self.disabledSelected = selected
        }
        
        init(active: T, selected: T, disabled: T) {
            self.active = active
            self.selected = selected
            self.disabled = disabled
            self.disabledSelected = disabled
        }
        
        init(active: T, selected: T, disabled: T, disabledSelected: T) {
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

// MARK: Switch
open class Switch: FormsComponent, FormsComponentWithGroup, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    private let backgroundView = UIView()
        .with(width: 320, height: 40)
        .with(isUserInteractionEnabled: true)
    private let switchView = UISwitch()
        .with(contentHuggingPriority: .required, axis: .horizontal)
        .with(contentCompressionResistancePriority: .required, axis: .horizontal)
        .with(contentMode: .center)
        .with(width: 40, height: 40)
    private let contentView = UIView()
        .with(width: 200, height: 40)
    private let titleLabel = UILabel()
        .with(numberOfLines: 0)
        .with(width: 200, height: 40)
    private let valueLabel = UILabel()
        .with(numberOfLines: 0)
        .with(width: 200, height: 40)
    private let gestureRecognizer = UITapGestureRecognizer()
    
    open var animationTime: TimeInterval = 0.2
    open var backgroundColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryBackground) {
        didSet { self.updateState() }
    }
    open var groupKey: String? = nil
    open var isEnabled: Bool {
        get { return self.isUserInteractionEnabled }
        set { newValue ? self.enable(animated: false) : self.disable(animated: false) }
    }
    private var _isSelected: Bool = false {
        didSet {
            self.updateState(animated: false)
            self.switchView.setOn(self._isSelected, animated: true)
        }
    }
    open var isSelected: Bool {
        get { return self._isSelected }
        set {
            self._isSelected = newValue
            self.updateGroup()
        }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var switchColors: State<UIColor?> = State<UIColor?>(Theme.Colors.tertiaryBackground) {
        didSet { self.updateState() }
    }
    open var switchThumbColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryText) {
        didSet { self.updateState() }
    }
    open var title: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    open var titleColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryText) {
        didSet { self.updateState() }
    }
    open var titleFonts: State<UIFont> = State<UIFont>(Theme.Fonts.bold(ofSize: 12)) {
        didSet { self.updateState() }
    }
    open var value: String? {
        get { return self.valueLabel.text }
        set { self.valueLabel.text = newValue }
    }
    open var valueColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryText) {
        didSet { self.updateState() }
    }
    open var valueFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 10)) {
        didSet { self.updateState() }
    }
    
    public var onValueChanged: ((Bool) -> Void)? = nil
    
    private (set) var state: StateType = StateType.active
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupSwitchView()
        self.setupContentView()
        self.setupTitleLabel()
        self.setupValueLabel()
        super.setupView()
    }
    
    override open func setupActions() {
        super.setupActions()
        self.switchView.addTarget(self, action: #selector(handleOnValueChanged), for: .valueChanged)
        self.gestureRecognizer.addTarget(self, action: #selector(handleGesture))
            self.backgroundView.addGestureRecognizer(self.gestureRecognizer)
    }
    
    @objc
    private func handleOnValueChanged(_ sender: UISwitch) {
        self.isSelected.toggle()
        self.onValueChanged?(self.isSelected)
    }
    
    @objc
    private func handleGesture(recognizer: UITapGestureRecognizer) {
        self.isSelected.toggle()
        self.onValueChanged?(self.isSelected)
    }
    
    override open func enable(animated: Bool) {
        guard !self.isUserInteractionEnabled else { return }
        self.isUserInteractionEnabled = true
        self.setState(.active, animated: animated)
    }
    
    override open func disable(animated: Bool) {
        guard self.isUserInteractionEnabled else { return }
        self.isUserInteractionEnabled = false
        if !self.isSelected {
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
    
    open func setupSwitchView() {
        self.backgroundView.addSubview(self.switchView, with: [
            Anchor.to(self.backgroundView).top,
            Anchor.to(self.backgroundView).trailing,
            Anchor.to(self.backgroundView).bottom.greaterThanOrEqual
        ])
    }
    
    open func setupContentView() {
        self.backgroundView.addSubview(self.contentView, with: [
            Anchor.to(self.backgroundView).top.greaterThanOrEqual,
            Anchor.to(self.switchView).trailingToLeading.offset(8),
            Anchor.to(self.backgroundView).leading,
            Anchor.to(self.backgroundView).bottom.greaterThanOrEqual,
            Anchor.to(self.backgroundView).centerY
        ])
    }
    
    open func setupTitleLabel() {
        self.contentView.addSubview(self.titleLabel, with: [
            Anchor.to(self.contentView).top,
            Anchor.to(self.contentView).horizontal
        ])
    }
    
    open func setupValueLabel() {
        self.contentView.addSubview(self.valueLabel, with: [
            Anchor.to(self.titleLabel).topToBottom,
            Anchor.to(self.contentView).horizontal,
            Anchor.to(self.contentView).bottom
        ])
    }
    
    open func updateGroup() {
        self.table?.views
            .compactMap { $0 as? Switch }
            .filter { $0.groupKey.isNotNil }
            .filter { $0.groupKey == self.groupKey }
            .filter { $0 !== self }
            .forEach { $0._isSelected = false }
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
        self.switchView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.switchView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.switchView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.contentView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.contentView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.contentView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
    }
     
    private func updateState(animated: Bool) {
        if !self.isEnabled && !self.isSelected {
            self.setState(.disabled, animated: animated)
        } else if !self.isEnabled && self.isSelected {
            self.setState(.disabledSelected, animated: animated)
        } else if self.isSelected {
            self.setState(.selected, animated: animated)
        } else {
            self.setState(.active, animated: animated)
        }
    }
    
    private func updateState() {
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
            self.backgroundView.backgroundColor = self.backgroundColors.value(for: state)
            self.switchView.onTintColor = self.switchColors.value(for: state)
            self.switchView.thumbTintColor = self.switchThumbColors.value(for: state)
            self.titleLabel.textColor = self.titleColors.value(for: state)
            self.titleLabel.font = self.titleFonts.value(for: state)
            self.valueLabel.textColor = self.valueColors.value(for: state)
            self.valueLabel.font = self.valueFonts.value(for: state)
        }
        self.state = state
    }
}

// MARK: Switch
public extension Switch {
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
    func with(isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }
    func with(isSelected: Bool) -> Self {
        self.isSelected = isSelected
        return self
    }
    func with(switchColor: UIColor?) -> Self {
        self.switchColors = State<UIColor?>(switchColor)
        return self
    }
    func with(switchColors: State<UIColor?>) -> Self {
        self.switchColors = switchColors
        return self
    }
    func with(switchThumbColor: UIColor?) -> Self {
        self.switchThumbColors = State<UIColor?>(switchThumbColor)
        return self
    }
    func with(switchThumbColors: State<UIColor?>) -> Self {
        self.switchThumbColors = switchThumbColors
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
    func with(value: String?) -> Self {
        self.value = value
        return self
    }
    func with(valueColor: UIColor?) -> Self {
        self.valueColors = State<UIColor?>(valueColor)
        return self
    }
    func with(valueColors: State<UIColor?>) -> Self {
        self.valueColors = valueColors
        return self
    }
    func with(valueFont: UIFont) -> Self {
        self.valueFonts = State<UIFont>(valueFont)
        return self
    }
    func with(valueFonts: State<UIFont>) -> Self {
        self.valueFonts = valueFonts
        return self
    }
}
