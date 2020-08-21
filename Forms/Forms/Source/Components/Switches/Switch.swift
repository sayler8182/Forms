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
    struct State<T>: FormsComponentStateActiveSelectedDisabledDisabledSelected {
        public var active: T!
        public var selected: T!
        public var disabled: T!
        public var disabledSelected: T!
        
        public init() { }
    }
}

// MARK: Switch
open class Switch: FormsComponent, FormsComponentWithGroup, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
        .with(width: 320, height: 40)
        .with(isUserInteractionEnabled: true)
    public let switchView = UISwitch()
        .with(contentHuggingPriority: .required, axis: .horizontal)
        .with(contentCompressionResistancePriority: .required, axis: .horizontal)
        .with(contentMode: .center)
        .with(width: 40, height: 40)
    public let contentView = UIView()
        .with(width: 200, height: 40)
    public let titleLabel = UILabel()
        .with(numberOfLines: 0)
        .with(width: 200, height: 40)
    public let valueLabel = UILabel()
        .with(numberOfLines: 0)
        .with(width: 200, height: 40)
    public let gestureRecognizer = UITapGestureRecognizer()
    
    open var animationTime: TimeInterval = 0.2
    open var backgroundColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryLight) {
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
    open var switchColors: State<UIColor?> = State<UIColor?>(Theme.Colors.tertiaryLight) {
        didSet { self.updateState() }
    }
    open var switchThumbColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryDark) {
        didSet { self.updateState() }
    }
    open var title: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    open var titleColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryDark) {
        didSet { self.updateState() }
    }
    open var titleFonts: State<UIFont> = State<UIFont>(Theme.Fonts.bold(ofSize: 12)) {
        didSet { self.updateState() }
    }
    open var value: String? {
        get { return self.valueLabel.text }
        set { self.valueLabel.text = newValue }
    }
    open var valueColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryDark) {
        didSet { self.updateState() }
    }
    open var valueFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 10)) {
        didSet { self.updateState() }
    }
    
    public var onValueChanged: ((Bool) -> Void)? = nil
    
    private (set) var state: FormsComponentStateType = .active
    
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
        self.isUserInteractionEnabled = true
        self.setState(.active, animated: animated)
    }
    
    override open func disable(animated: Bool) {
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
        let views: [UIView] = self.table?.views ?? []
        for view in views {
            guard let _switch: Switch = view as? Switch else { continue }
            guard _switch.groupKey != nil else { continue }
            guard _switch.groupKey == self.groupKey else { continue }
            guard _switch !== self else { continue }
            _switch._isSelected = false
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
        self.switchView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.switchView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.switchView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.contentView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.contentView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.contentView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
    }
    
    public func updateState(animated: Bool) {
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
        self.switchView.onTintColor = self.switchColors.value(for: state)
        self.switchView.thumbTintColor = self.switchThumbColors.value(for: state)
        self.titleLabel.textColor = self.titleColors.value(for: state)
        self.titleLabel.font = self.titleFonts.value(for: state)
        self.valueLabel.textColor = self.valueColors.value(for: state)
        self.valueLabel.font = self.valueFonts.value(for: state)
    }
}

// MARK: Builder
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
