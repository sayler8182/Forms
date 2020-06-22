//
//  TextField.swift
//  Forms
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsValidators
import UIKit

// MARK: State
public extension TextField {
    struct State<T>: FormsComponentStateActiveSelectedDisabledError {
        public var active: T!
        public var selected: T!
        public var disabled: T!
        public var error: T!
        
        public init() { }
    }
}

// MARK: UITextFieldWithPlaceholder
open class UITextFieldWithPlaceholder: UITextField, UnShimmerable {
    public typealias OnDeleteBackward = () -> Void
    
    public let placeholderLabel = UILabel()
        .with(width: 320, height: 20)
    public let maskLabel = UILabel()
        .with(width: 320, height: 20)
    
    private let padding: UIEdgeInsets = UIEdgeInsets(0)
    
    override open var attributedText: NSAttributedString! {
        get { return super.attributedText }
        set {
            super.attributedText = newValue
            self.updateView()
        }
    }
    override open var font: UIFont! {
        get { return super.font }
        set {
            super.font = newValue
            self.updateView()
        }
    }
    open var maskText: String? = nil {
        didSet { self.updateView() }
    }
    open var maskAttributedText: NSAttributedString? {
        get { return self.maskLabel.attributedText }
        set { self.maskLabel.attributedText = newValue }
    }
    open var maskColor: UIColor? {
        get { return self.maskLabel.textColor }
        set { self.maskLabel.textColor = newValue }
    }
    open var maskFont: UIFont {
        get { return self.maskLabel.font }
        set { self.maskLabel.font = newValue }
    }
    override open var placeholder: String? {
        get { return self.placeholderLabel.text }
        set { self.placeholderLabel.text = newValue }
    }
    open var placeholderAttributedText: NSAttributedString? {
        get { return self.placeholderLabel.attributedText }
        set { self.placeholderLabel.attributedText = newValue }
    }
    open var placeholderColor: UIColor? {
        get { return self.placeholderLabel.textColor }
        set { self.placeholderLabel.textColor = newValue }
    }
    open var placeholderFont: UIFont {
        get { return self.placeholderLabel.font }
        set { self.placeholderLabel.font = newValue }
    }
    override open var text: String! {
        get { return super.text }
        set {
            super.text = newValue
            self.updateView()
        }
    }
    override open var textAlignment: NSTextAlignment {
        get { return super.textAlignment }
        set {
            super.textAlignment = newValue
            self.placeholderLabel.textAlignment = newValue
            self.maskLabel.textAlignment = newValue
        }
    }
    
    public var onDeleteBackward: OnDeleteBackward?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    public init() {
        super.init(frame: CGRect(width: 320, height: 44))
        self.setupView()
        self.setupActions()
    }
    
    open func setupView() {
        self.setupPlaceholder()
        self.setupMask()
        self.sendSubviewToBack(self.maskLabel)
        self.sendSubviewToBack(self.placeholderLabel)
    }
    
    open func setupActions() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChangeNotification),
            name: UITextField.textDidChangeNotification,
            object: self)
    }
    
    override open func deleteBackward() {
        super.deleteBackward()
        self.onDeleteBackward?()
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }
    
    private func setupPlaceholder() {
        self.addSubview(self.placeholderLabel, with: [
            Anchor.to(self).top,
            Anchor.to(self).horizontal,
            Anchor.to(self).bottom.offset(1.0)
        ])
    }
    private func setupMask() {
        self.addSubview(self.maskLabel, with: [
            Anchor.to(self).top,
            Anchor.to(self).horizontal,
            Anchor.to(self).bottom.offset(1.0)
        ])
    }
    
    private func updateView() {
        self.placeholderLabel.isHidden = self.text.isNotNilOrEmpty
        self.maskLabel.isHidden = !self.placeholderLabel.isHidden && self.maskText.isNilOrEmpty
        self.updateMaskPosition()
    }
    
    private func updateMaskPosition() {
        let textCount: Int = self.text.or("").count
        let maskCount: Int = self.maskText.or("").count
        if maskCount - textCount > 0 {
            self.maskLabel.text = self.maskText?[textCount..<maskCount]
        } else {
            self.maskLabel.text = nil
            self.maskLabel.isHidden = true
        }
        if textCount != 0 {
            let textWidth: CGFloat = self.intrinsicContentSize.width
            self.maskLabel.constraint(to: self, position: .leading)?.constant = textWidth
            self.layoutIfNeeded()
        } else {
            self.maskLabel.constraint(to: self, position: .leading)?.constant = 0.0
            self.layoutIfNeeded()
        }
    }
    
    @objc
    private func textDidChangeNotification(_ notification: Notification) {
        self.updateView()
    }
}

// MARK: TextField
open class TextField: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
        .with(width: 320, height: 85)
        .with(isUserInteractionEnabled: true)
    public let titleLabel = UnShimmerableLabel()
        .with(width: 320, height: 20)
    public let textField = UITextFieldWithPlaceholder()
        .with(width: 320, height: 44)
    public let underscoreView = UnShimmerableView()
        .with(width: 320, height: 1)
    public let errorLabel = UnShimmerableLabel()
        .with(width: 320, height: 20)
    public let infoLabel = UnShimmerableLabel()
        .with(width: 320, height: 20)
    public let gestureRecognizer = UITapGestureRecognizer()
    
    open var animationTime: TimeInterval = 0.2
    open var autocapitalizationType: UITextAutocapitalizationType {
        get { return self.textField.autocapitalizationType }
        set { self.textField.autocapitalizationType = newValue }
    }
    open var autocorrectionType: UITextAutocorrectionType {
        get { return self.textField.autocorrectionType }
        set { self.textField.autocorrectionType = newValue }
    }
    open var backgroundColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryLight) {
        didSet { self.updateState() }
    }
    open var error: String? {
        didSet { self.updateError() }
    }
    open var errorColor: UIColor = Theme.Colors.red {
        didSet { self.updateState() }
    }
    open var errorFont: UIFont = Theme.Fonts.regular(ofSize: 10) {
        didSet { self.updateState() }
    }
    open var info: String? {
        get { return self.infoLabel.text }
        set { self.infoLabel.text = newValue }
    }
    open var infoColor: UIColor = Theme.Colors.gray {
        didSet { self.updateState() }
    }
    open var infoFont: UIFont = Theme.Fonts.regular(ofSize: 10) {
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
    open var maskText: String? {
        get { return self.textField.maskText }
        set { self.textField.maskText = newValue }
    }
    open var maskColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryDark.with(alpha: 0.3)) {
        didSet { self.updateState() }
    }
    open var maskFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 16)) {
        didSet { self.updateState() }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var placeholder: String? {
        get { return self.textField.placeholder }
        set { self.textField.placeholder = newValue }
    }
    open var placeholderColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryDark.with(alpha: 0.3)) {
        didSet { self.updateState() }
    }
    open var placeholderFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 16)) {
        didSet { self.updateState() }
    }
    @available(iOS 11.0, *)
    open var smartQuotesType: UITextSmartQuotesType {
        get { return self.textField.smartQuotesType }
        set { self.textField.smartQuotesType = newValue }
    }
    open var text: String? {
        get { return self.textField.text }
        set { self.textField.text = newValue }
    }
    open var textColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryDark) {
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
    open var textFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 16)) {
        didSet { self.updateState() }
    }
    open var title: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    open var titleColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryDark) {
        didSet { self.updateState() }
    }
    open var titleFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 10)) {
        didSet { self.updateState() }
    }
    open var underscoreColors: State<UIColor?> = State<UIColor?>(Theme.Colors.gray) {
        didSet { self.updateState() }
    }
    
    public var validateOnTextChangeAfterEndEditing: Bool = false
    public var validateOnBeginEditing: Bool = false
    public var validateOnEndEditing: Bool = false
    public var validateOnTextChange: Bool = false
    public var validators: [Validator] = []
    public var validatorTriggered: Bool = false
    
    public var formatText: ((String?) -> String?)?
    
    public var onBeginEditing: ((String?) -> Void)?
    public var onDidPaste: ((String?, String) -> Void)?
    public var onEndEditing: ((String?) -> Void)?
    public var onTextChanged: ((String?) -> Void)?
    public var onValidate: Validable.OnValidate?
    
    private (set) var state: FormsComponentStateType = .active
    
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
        self.gestureRecognizer.addTarget(self, action: #selector(handleGesture))
        self.backgroundView.addGestureRecognizer(self.gestureRecognizer)
    }
    
    @objc
    private func handleGesture(recognizer: UITapGestureRecognizer) {
        self.textField.becomeFirstResponder()
    }
    
    override open func enable(animated: Bool) {
        self.isUserInteractionEnabled = true
        self.setState(.active, animated: animated)
    }
    
    override open func disable(animated: Bool) {
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
    private func handleOnEndEditing(_ sender: UITextField) {
        self.updateState(animated: true)
        self.validatorTrigger()
        self.onEndEditing?(sender.text)
        if self.validateOnEndEditing {
            self.validate()
            self.table?.refreshTableView()
        }
        if self.validateOnTextChangeAfterEndEditing {
            self.validateOnTextChange = true
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
    
    // MARK: UIResponder 
    override open var canBecomeFirstResponder: Bool {
        return self.textField.canBecomeFirstResponder
    }
    
    override open func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }
    
    override open var canResignFirstResponder: Bool {
        return self.textField.canBecomeFirstResponder
    }
    
    override open func resignFirstResponder() -> Bool {
        return self.textField.resignFirstResponder()
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
    
    public func updateState(animated: Bool) {
        if self.error.isNotNilOrEmpty {
            self.setState(.error, animated: animated)
        } else if !self.isEnabled {
            self.setState(.disabled, animated: animated)
        } else if self.textField.isFirstResponder {
            self.setState(.selected, animated: animated)
        } else {
            self.setState(.active, animated: animated)
        }
    }
    
    public func updateState() {
        self.setState(self.state, animated: false, force: true)
    }
    
    private func setState(_ state: FormsComponentStateType,
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
        self.errorLabel.textColor = self.errorColor
        self.errorLabel.font = self.errorFont
        self.infoLabel.textColor = self.infoColor
        self.infoLabel.font = self.infoFont
        self.textField.textColor = self.textColors.value(for: state)
        self.textField.font = self.textFonts.value(for: state)
        self.textField.placeholderColor = self.placeholderColors.value(for: state)
        self.textField.placeholderFont = self.placeholderFonts.value(for: state)
        self.textField.maskColor = self.maskColors.value(for: state)
        self.textField.maskFont = self.maskFonts.value(for: state)
        self.titleLabel.textColor = self.titleColors.value(for: state)
        self.titleLabel.font = self.titleFonts.value(for: state)
        self.underscoreView.backgroundColor = self.underscoreColors.value(for: state)
    }
}

// MARK: Validable
extension TextField: Validable {
    public func validate(_ validator: Validator,
                         _ isSilence: Bool) -> Bool {
        let result = validator.validate(self.text)
        if !isSilence {
            self.error = self.validatorTriggered ? result.description : nil
        }
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
    func with(maskText: String?) -> Self {
        self.maskText = maskText
        return self
    }
    func with(maskColor: UIColor?) -> Self {
        self.maskColors = State<UIColor?>(maskColor)
        return self
    }
    func with(maskColors: State<UIColor?>) -> Self {
        self.maskColors = maskColors
        return self
    }
    func with(maskFont: UIFont) -> Self {
        self.maskFonts = State<UIFont>(maskFont)
        return self
    }
    func with(maskFonts: State<UIFont>) -> Self {
        self.maskFonts = maskFonts
        return self
    }
    func with(placeholder: String?) -> Self {
        self.placeholder = placeholder
        return self
    }
    func with(placeholderColor: UIColor?) -> Self {
        self.placeholderColors = State<UIColor?>(placeholderColor)
        return self
    }
    func with(placeholderColors: State<UIColor?>) -> Self {
        self.placeholderColors = placeholderColors
        return self
    }
    func with(placeholderFont: UIFont) -> Self {
        self.placeholderFonts = State<UIFont>(placeholderFont)
        return self
    }
    func with(placeholderFonts: State<UIFont>) -> Self {
        self.placeholderFonts = placeholderFonts
        return self
    }
    @available(iOS 11.0, *)
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
    func with(underscoreColor: UIColor?) -> Self {
        self.underscoreColors = State<UIColor?>(underscoreColor)
        return self
    }
    func with(underscoreColors: State<UIColor?>) -> Self {
        self.underscoreColors = underscoreColors
        return self
    }
    func with(validateOnTextChangeAfterEndEditing: Bool) -> Self {
        self.validateOnTextChangeAfterEndEditing = validateOnTextChangeAfterEndEditing
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

// MARK: UITextField
public extension UITextField {
    var formTextField: TextField? {
        var superview: UIView? = self
        while superview != nil {
            superview = superview?.superview
            guard let textField = superview as? TextField else { continue }
            return textField
        }
        return nil
    }
}
