//
//  SearchBar.swift
//  Forms
//
//  Created by Konrad on 4/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import UIKit
import Validators

// MARK: State
public extension SearchBar {
    enum StateType {
        case active
        case selected
        case disabled
    }
    
    struct State<T> {
        let active: T
        let selected: T
        let disabled: T
        
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

// MARK: SearchBar
open class SearchBar: FormComponent, FormComponentWithMarginEdgeInset, FormComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
        .with(width: 320, height: 85)
    public let searchBar = UISearchBar()
        .with(width: 320, height: 44)
    
    open var animationTime: TimeInterval = 0.2
    open var autocapitalizationType: UITextAutocapitalizationType {
        get { return self.searchBar.autocapitalizationType }
        set { self.searchBar.autocapitalizationType = newValue }
    }
    open var autocorrectionType: UITextAutocorrectionType {
        get { return self.searchBar.autocorrectionType }
        set { self.searchBar.autocorrectionType = newValue }
    }
    open var backgroundColors: State<UIColor?> = State<UIColor?>(UIColor.systemBackground) {
        didSet { self.updateState() }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var isEnabled: Bool {
        get { return self.isUserInteractionEnabled }
        set { newValue ? self.enable(animated: false) : self.disable(animated: false) }
    }
    open var keyboardType: UIKeyboardType {
        get { return self.searchBar.keyboardType }
        set { self.searchBar.keyboardType = newValue }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var placeholder: String? {
        get { return self.searchBar.placeholder }
        set { self.searchBar.placeholder = newValue }
    }
    open var smartQuotesType: UITextSmartQuotesType {
        get { return self.searchBar.smartQuotesType }
        set { self.searchBar.smartQuotesType = newValue }
    }
    open var text: String? {
        get { return self.searchBar.text }
        set { self.searchBar.text = newValue }
    }
    open var textColors: State<UIColor?> = State<UIColor?>(UIColor.label) {
        didSet { self.updateState() }
    }
    private var _textFieldDelegate: UITextFieldDelegate? // swiftlint:disable:this weak_delegate
    open var textFieldDelegate: UITextFieldDelegate? {
        get { return self._textFieldDelegate }
        set {
            self._textFieldDelegate = newValue
            self.searchBar.searchTextField.delegate = newValue
        }
    }
    open var textFonts: State<UIFont> = State<UIFont>(UIFont.systemFont(ofSize: 14)) {
        didSet { self.updateState() }
    }
    
    public var validateOnBeginEditing: Bool = false
    public var validateOnEndEditing: Bool = false
    public var validateOnTextChange: Bool = false
    public var validators: [Validator] = []
    public var validatorTriggered: Bool = false
    
    public var formatText: ((String?) -> String?)?
    
    public var onBeginEditing: ((String?) -> Void)?
    public var onDidPaste: ((String?) -> Void)?
    public var onEndEditing: ((String?) -> Void)?
    public var onTextChanged: ((String?) -> Void)?
    
    private (set) var state: StateType = StateType.active
    
    override open var intrinsicContentSize: CGSize {
      return UIView.layoutFittingExpandedSize
    }
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupSearchBar()
        super.setupView()
    }
    
    override open func setupActions() {
        super.setupActions()
        self.searchBar.searchTextField.addTarget(self, action: #selector(handleOnBeginEditing), for: .editingDidBegin)
        self.searchBar.searchTextField.addTarget(self, action: #selector(handleOnEndEditing), for: .editingDidEnd)
        self.searchBar.searchTextField.addTarget(self, action: #selector(handleOnTextChanged), for: .editingChanged)
    }
    
    override open func enable(animated: Bool) {
        guard !self.isUserInteractionEnabled else { return }
        self.isUserInteractionEnabled = true
        self.setState(.active, animated: animated)
    }
    
    override open func disable(animated: Bool) {
        guard self.isUserInteractionEnabled else { return }
        self.isUserInteractionEnabled = false
        self.setState(.disabled, animated: animated)
    }
    
    public func textFieldDelegate<T: UITextFieldDelegate>(of type: T.Type) -> T? {
        return self._textFieldDelegate as? T
    }
    
    // MARK: Actions
    @objc
    private func handleOnBeginEditing(_ sender: UITextField) {
        self.updateState(animated: true)
        self.validatorTrigger()
        if let newText: String = self.formatText?(sender.text) {
            sender.text = newText
        }
        self.onBeginEditing?(sender.text)
        if self.validateOnBeginEditing {
            self.validate()
            self.table?.refreshTableView()
        }
    }
    
    @objc
    private func handleOnDidPaste(_ sender: UITextField) {
        self.validatorTrigger()
        self.onDidPaste?(sender.text)
    }
    
    @objc
    private func handleOnEndEditing(_ sender: UITextField) {
        self.updateState(animated: true)
        self.validatorTrigger()
        self.onEndEditing?(sender.text)
        if self.validateOnEndEditing {
            self.validate()
            self.table?.refreshTableView()
        }
    }
    
    @objc
    private func handleOnTextChanged(_ sender: UITextField) {
        self.validatorTrigger()
        self.onTextChanged?(sender.text)
        if self.validateOnTextChange {
            self.validate()
            self.table?.refreshTableView()
        }
    }
    
    open func setupBackgroundView() {
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).top,
            Anchor.to(self).horizontal,
            Anchor.to(self).bottom
        ])
    }
    
    open func setupSearchBar() {
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.searchTextField.anchors([
            Anchor.to(self.searchBar).fill,
            Anchor.to(self.searchBar.searchTextField).height(36)
        ])
        self.backgroundView.addSubview(self.searchBar, with: [
            Anchor.to(self.backgroundView).top.offset(self.paddingEdgeInset.top),
            Anchor.to(self.backgroundView).bottom.offset(self.paddingEdgeInset.bottom),
            Anchor.to(self.backgroundView).leading.offset(self.paddingEdgeInset.leading),
            Anchor.to(self.backgroundView).trailing.offset(self.paddingEdgeInset.trailing)
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
        self.searchBar.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.searchBar.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.searchBar.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.searchBar.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    private func updateState(animated: Bool) {
        if self.isEnabled.not {
            self.setState(.disabled, animated: animated)
        } else if self.isFirstResponder {
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
        }
    }
    
    private func setState(_ state: StateType,
                          animated: Bool,
                          force: Bool = false) {
        guard self.state != state || force else { return }
        self.animation(animated, duration: self.animationTime) {
            self.backgroundView.backgroundColor = self.backgroundColors.value(for: state)
            self.searchBar.searchTextField.textColor = self.textColors.value(for: state)
            self.searchBar.searchTextField.font = self.textFonts.value(for: state)
        }
        self.state = state
    }
}

// MARK: Validadble
extension SearchBar: Validable {
    public func validate(_ validator: Validator) -> Bool {
        return validator.validate(self.text).isValid
    }
}

// MARK: Inputable
extension SearchBar: Inputable {
    public func focus(animated: Bool) {
        self.searchBar.becomeFirstResponder()
    }
    
    public func lostFocus(animated: Bool) {
        self.searchBar.resignFirstResponder()
    }
}

// MARK: Builder
public extension SearchBar {
    func with(animationTime: TimeInterval) -> Self {
        self.animationTime = animationTime
        return self
    }
    func with(autocapitalizationType: UITextAutocapitalizationType) -> Self {
        self.autocapitalizationType = autocapitalizationType
        return self
    }
    func with(autocorrectionType: UITextAutocorrectionType) -> Self {
        self.autocorrectionType = autocorrectionType
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
    func with(keyboardType: UIKeyboardType) -> Self {
        self.keyboardType = keyboardType
        return self
    }
    func with(placeholder: String?) -> Self {
        self.placeholder = placeholder
        return self
    }
    func with(smartQuotesType: UITextSmartQuotesType) -> Self {
        self.smartQuotesType = smartQuotesType
        return self
    }
    func with(text: String?) -> Self {
        self.text = text
        return self
    }
    func with(textColor: UIColor?) -> Self {
        self.textColors = State<UIColor?>(textColor)
        return self
    }
    func with(textColors: State<UIColor?>) -> Self {
        self.textColors = textColors
        return self
    }
    func with(textFieldDelegate: UITextFieldDelegate?) -> Self {
        self.textFieldDelegate = textFieldDelegate
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
    func with(validateOnBeginEditing: Bool) -> Self {
        self.validateOnBeginEditing = validateOnBeginEditing
        return self
    }
    func with(validateOnEndEditing: Bool) -> Self {
        self.validateOnEndEditing = validateOnEndEditing
        return self
    }
    func with(validateOnTextChange: Bool) -> Self {
        self.validateOnTextChange = validateOnTextChange
        return self
    }
    func with(validator: Validator) -> Self {
        self.validators = [validator]
        return self
    }
    func with(validators: [Validator]) -> Self {
        self.validators = validators
        return self
    }
    func with(validatorTriggered: Bool) -> Self {
        self.validatorTriggered = validatorTriggered
        return self
    }
    func with(formatText: ((String?) -> String?)?) -> Self {
        self.formatText = formatText
        return self
    }
}
