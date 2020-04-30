//
//  TextField.swift
//  Forms
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import UIKit
import Validators

// MARK: State
public extension TextField {
    enum StateType {
        case active
        case selected
        case disabled
        case error
    }
    
    struct State<T> {
        let active: T
        let selected: T
        let disabled: T
        let error: T
        
        init(_ value: T) {
            self.active = value
            self.selected = value
            self.disabled = value
            self.error = value
        }
        
        init(active: T, selected: T, disabled: T, error: T) {
            self.active = active
            self.selected = selected
            self.disabled = disabled
            self.error = error
        }
        
        func value(for state: StateType) -> T {
            switch state {
            case .active: return self.active
            case .selected: return self.selected
            case .disabled: return self.disabled
            case .error: return self.error
            }
        }
    }
}

// TextField
open class UITextFieldWithoutPadding: UITextField {
    private let padding: UIEdgeInsets = UIEdgeInsets(0)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }
}

// MARK: TextField
open class TextField: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
        .with(width: 320, height: 85)
    public let titleLabel = UILabel()
        .with(width: 320, height: 20)
    public let textField = UITextFieldWithoutPadding()
        .with(width: 320, height: 44)
    public let underscoreView = UIView()
        .with(width: 320, height: 1)
    public let errorLabel = UILabel()
        .with(width: 320, height: 20)
    public let infoLabel = UILabel()
        .with(width: 320, height: 20)
    
    open var animationTime: TimeInterval = 0.2
    open var autocapitalizationType: UITextAutocapitalizationType {
        get { return self.textField.autocapitalizationType }
        set { self.textField.autocapitalizationType = newValue }
    }
    open var autocorrectionType: UITextAutocorrectionType {
        get { return self.textField.autocorrectionType }
        set { self.textField.autocorrectionType = newValue }
    }
    open var backgroundColors: State<UIColor?> = State<UIColor?>(UIColor.systemBackground) {
        didSet { self.updateState() }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var error: String? {
        didSet { self.updateError() }
    }
    open var errorColor: UIColor = UIColor.red {
        didSet { self.updateState() }
    }
    open var errorFont: UIFont = UIFont.systemFont(ofSize: 10) {
        didSet { self.updateState() }
    }
    open var info: String? {
        get { return self.infoLabel.text }
        set { self.infoLabel.text = newValue }
    }
    open var infoColor: UIColor = UIColor.lightGray {
        didSet { self.updateState() }
    }
    open var infoFont: UIFont = UIFont.systemFont(ofSize: 10) {
        didSet { self.updateState() }
    }
    open var isEnabled: Bool {
        get { return self.isUserInteractionEnabled }
        set { newValue ? self.enable(animated: false) : self.disable(animated: false) }
    }
    open var isSecureTextEntry: Bool {
        get { return self.textField.isSecureTextEntry }
        set { self.textField.isSecureTextEntry = newValue }
    }
    open var keyboardType: UIKeyboardType {
        get { return self.textField.keyboardType }
        set { self.textField.keyboardType = newValue }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var placeholder: String? {
        get { return self.textField.placeholder }
        set { self.textField.placeholder = newValue }
    }
    open var smartQuotesType: UITextSmartQuotesType {
        get { return self.textField.smartQuotesType }
        set { self.textField.smartQuotesType = newValue }
    }
    open var text: String? {
        get { return self.textField.text }
        set { self.textField.text = newValue }
    }
    open var textColors: State<UIColor?> = State<UIColor?>(UIColor.label) {
        didSet { self.updateState() }
    }
    private var _textFieldDelegate: UITextFieldDelegate? // swiftlint:disable:this weak_delegate
    open var textFieldDelegate: UITextFieldDelegate? {
        get { return self._textFieldDelegate }
        set {
            self._textFieldDelegate = newValue
            self.textField.delegate = newValue
        }
    }
    open var textFonts: State<UIFont> = State<UIFont>(UIFont.systemFont(ofSize: 14)) {
        didSet { self.updateState() }
    }
    open var title: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    open var titleColors: State<UIColor?> = State<UIColor?>(UIColor.label) {
        didSet { self.updateState() }
    }
    open var titleFonts: State<UIFont> = State<UIFont>(UIFont.systemFont(ofSize: 10)) {
        didSet { self.updateState() }
    }
    open var underscoreColor: UIColor = UIColor.lightGray {
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
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupTitleLabel()
        self.setupTextField()
        self.setupUnderscoreView()
        self.setupErrorLabel()
        self.setupInfoLabel()
        super.setupView()
    }
    
    override open func setupActions() {
        super.setupActions()
        self.textField.addTarget(self, action: #selector(handleOnBeginEditing), for: .editingDidBegin)
        self.textField.addTarget(self, action: #selector(handleOnEndEditing), for: .editingDidEnd)
        self.textField.addTarget(self, action: #selector(handleOnTextChanged), for: .editingChanged)
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
    
    // MARK: HOOKS - setup
    open func setupBackgroundView() {
        // HOOK
    }
    
    open func setupTitleLabel() {
        // HOOK
    }
    
    open func setupTextField() {
        // HOOK
    }
    
    open func setupUnderscoreView() {
        // HOOK
    }
    
    open func setupErrorLabel() {
        self.errorLabel.numberOfLines = 0
        // HOOK
    }
    
    open func setupInfoLabel() {
        self.infoLabel.numberOfLines = 0
        // HOOK
    }
    
    open func updateError() {
        self.errorLabel.text = self.error
        self.updateState(animated: true)
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
        // HOOK
    }
    
    private func updateState(animated: Bool) {
        if self.error.isNotNilOrEmpty {
            self.setState(.error, animated: animated)
        } else if self.isEnabled.not {
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
        case .error: self.setState(.error, animated: false, force: true)
        }
    }
    
    private func setState(_ state: StateType,
                          animated: Bool,
                          force: Bool = false) {
        guard self.state != state || force else { return }
        self.animation(animated, duration: self.animationTime) {
            self.backgroundView.backgroundColor = self.backgroundColors.value(for: state)
            self.errorLabel.textColor = self.errorColor
            self.errorLabel.font = self.errorFont
            self.infoLabel.textColor = self.infoColor
            self.infoLabel.font = self.infoFont
            self.textField.textColor = self.textColors.value(for: state)
            self.textField.font = self.textFonts.value(for: state)
            self.titleLabel.textColor = self.titleColors.value(for: state)
            self.titleLabel.font = self.titleFonts.value(for: state)
            self.underscoreView.backgroundColor = self.underscoreColor
        }
        self.state = state
    }
}

// MARK: Validadble
extension TextField: Validable {
    public func validate(_ validator: Validator) -> Bool {
        let result = validator.validate(self.text)
        self.error = self.validatorTriggered ? result.description : nil
        return result.isValid
    }
}

// MARK: Inputable
extension TextField: Inputable {
    public func focus(animated: Bool) {
        self.textField.becomeFirstResponder()
    }
    
    public func lostFocus(animated: Bool) {
        self.textField.resignFirstResponder()
    }
}

// MARK: Builder
public extension TextField {
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
    func with(error: String?) -> Self {
        self.error = error
        return self
    }
    func with(errorColor: UIColor) -> Self {
        self.errorColor = errorColor
        return self
    }
    func with(errorFont: UIFont) -> Self {
        self.errorFont = errorFont
        return self
    }
    func with(info: String?) -> Self {
        self.info = info
        return self
    }
    func with(infoColor: UIColor) -> Self {
        self.infoColor = infoColor
        return self
    }
    func with(infoFont: UIFont) -> Self {
        self.infoFont = infoFont
        return self
    }
    func with(isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }
    func with(isSecureTextEntry: Bool) -> Self {
        self.isSecureTextEntry = isSecureTextEntry
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
    func with(underscoreColor: UIColor) -> Self {
        self.underscoreColor = underscoreColor
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
