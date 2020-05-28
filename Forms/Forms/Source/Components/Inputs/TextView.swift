//
//  TextView.swift
//  Forms
//
//  Created by Konrad on 5/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsValidators
import UIKit

// MARK: State
public extension TextView {
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

// MARK: UITextViewWithPlaceholder
open class UITextViewWithPlaceholder: UITextView {
    public let placeholderLabel = UILabel()
        .with(width: 320, height: 20)
    
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
    open var placeholder: String? {
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
    override open var textContainerInset: UIEdgeInsets {
        get { return super.textContainerInset }
        set {
            super.textContainerInset = newValue
            self.updateView()
        }
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    public init() {
        super.init(frame: CGRect(width: 320, height: 44), textContainer: nil)
        self.setupView()
        self.setupActions()
    }
    
    open func setupView() {
        self.setupPlaceholder()
    }
    
    open func setupActions() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChangeNotification),
            name: UITextView.textDidChangeNotification,
            object: self)
    }
    
    private func setupPlaceholder() {
        self.addSubview(self.placeholderLabel, with: [
            Anchor.to(self).fill
        ])
        self.sendSubviewToBack(self.placeholderLabel)
    }
    
    private func updateView() {
        self.placeholderLabel.isHidden = self.text.isNotNilOrEmpty
    }
    
    @objc
    private func textDidChangeNotification(_ notification: Notification) {
        self.updateView()
    }
}

// MARK: TextView
open class TextView: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
        .with(width: 320, height: 85)
        .with(isUserInteractionEnabled: true)
    public let titleLabel = UILabel()
        .with(width: 320, height: 20)
    public let textView = UITextViewWithPlaceholder()
        .with(width: 320, height: 44)
    public let underscoreView = UIView()
        .with(width: 320, height: 1)
    public let errorLabel = UILabel()
        .with(width: 320, height: 20)
    public let infoLabel = UILabel()
        .with(width: 320, height: 20)
    private let gestureRecognizer = UITapGestureRecognizer()
    
    open var animationTime: TimeInterval = 0.2
    open var autocapitalizationType: UITextAutocapitalizationType {
        get { return self.textView.autocapitalizationType }
        set { self.textView.autocapitalizationType = newValue }
    }
    open var autocorrectionType: UITextAutocorrectionType {
        get { return self.textView.autocorrectionType }
        set { self.textView.autocorrectionType = newValue }
    }
    open var backgroundColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryBackground) {
        didSet { self.updateState() }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
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
    open var keyboardType: UIKeyboardType {
        get { return self.textView.keyboardType }
        set { self.textView.keyboardType = newValue }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var placeholder: String? {
        get { return self.textView.placeholder }
        set { self.textView.placeholder = newValue }
    }
    open var placeholderColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryText.withAlphaComponent(0.3)) {
        didSet { self.updateState() }
    }
    open var placeholderFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 16)) {
        didSet { self.updateState() }
    }
    @available(iOS 11.0, *)
    open var smartQuotesType: UITextSmartQuotesType {
        get { return self.textView.smartQuotesType }
        set { self.textView.smartQuotesType = newValue }
    }
    open var text: String? {
        get { return self.textView.text }
        set { self.textView.text = newValue }
    }
    open var textColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryText) {
        didSet { self.updateState() }
    }
    open var textFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 16)) {
        didSet { self.updateState() }
    }
    private var _textViewDelegate: UITextViewDelegate? // swiftlint:disable:this weak_delegate
    open var textViewDelegate: UITextViewDelegate? {
        get { return self._textViewDelegate }
        set { self._textViewDelegate = newValue }
    }
    open var title: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    open var titleColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryText) {
        didSet { self.updateState() }
    }
    open var titleFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 10)) {
        didSet { self.updateState() }
    }
    open var underscoreColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryText) {
        didSet { self.updateState() }
    }
    
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
    
    private (set) var state: StateType = StateType.active
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupTitleLabel()
        self.setupTextView()
        self.setupUnderscoreView()
        self.setupErrorLabel()
        self.setupInfoLabel()
        super.setupView()
    }
    
    override open func setupActions() {
        super.setupActions()
        self.gestureRecognizer.addTarget(self, action: #selector(handleGesture))
        self.backgroundView.addGestureRecognizer(self.gestureRecognizer)
    }
    
    @objc
    private func handleGesture(recognizer: UITapGestureRecognizer) {
        self.textView.becomeFirstResponder()
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
    
    public func textViewDelegate<T: UITextViewDelegate>(of type: T.Type) -> T? {
        return self._textViewDelegate as? T
    }
    
    // MARK: UIResponder
    override open var canBecomeFirstResponder: Bool {
        return self.textView.canBecomeFirstResponder
    }
    
    override open func becomeFirstResponder() -> Bool {
        return self.textView.becomeFirstResponder()
    }
    
    override open var canResignFirstResponder: Bool {
        return self.textView.canBecomeFirstResponder
    }
    
    override open func resignFirstResponder() -> Bool {
        return self.textView.resignFirstResponder()
    }
    
    // MARK: HOOKS - setup
    open func setupBackgroundView() {
        // HOOK
    }
    
    open func setupTitleLabel() {
        // HOOK
    }
    
    open func setupTextView() {
        self.textView.delegate = self
        self.textView.isScrollEnabled = false
        self.textView.textContainerInset = UIEdgeInsets.zero
        self.textView.textContainer.lineFragmentPadding = 0
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
        } else if self.textView.isFirstResponder {
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
            self.textView.textColor = self.textColors.value(for: state)
            self.textView.font = self.textFonts.value(for: state)
            self.textView.placeholderColor = self.placeholderColors.value(for: state)
            self.textView.placeholderFont = self.placeholderFonts.value(for: state)
            self.titleLabel.textColor = self.titleColors.value(for: state)
            self.titleLabel.font = self.titleFonts.value(for: state)
            self.underscoreView.backgroundColor = self.underscoreColors.value(for: state)
        }
        self.state = state
    }
}

// MARK: UITextViewDelegate
extension TextView: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.updateState(animated: true)
        self.validatorTrigger()
        if let newText: String = self.formatText?(textView.text) {
            textView.text = newText
        }
        self.onBeginEditing?(textView.text)
        if self.validateOnBeginEditing {
            self.validate()
            self.table?.refreshTableView()
        }
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        self.updateState(animated: true)
        self.validatorTrigger()
        self.onEndEditing?(textView.text)
        if self.validateOnEndEditing {
            self.validate()
            self.table?.refreshTableView()
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        self.table?.refreshTableView()
        self.validatorTrigger()
        self.onTextChanged?(textView.text)
        if self.validateOnTextChange {
            self.validate()
            self.table?.refreshTableView()
        }
    }
}

// MARK: Validable
extension TextView: Validable {
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
extension TextView: Inputable {
    public func focus(animated: Bool) {
        self.textView.becomeFirstResponder()
    }
    
    public func lostFocus(animated: Bool) {
        self.textView.resignFirstResponder()
    }
}

// MARK: Builder
public extension TextView {
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
    func with(keyboardType: UIKeyboardType) -> Self {
        self.keyboardType = keyboardType
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
    func with(textFont: UIFont) -> Self {
        self.textFonts = State<UIFont>(textFont)
        return self
    }
    func with(textFonts: State<UIFont>) -> Self {
        self.textFonts = textFonts
        return self
    }
    func with(textViewDelegate: UITextViewDelegate?) -> Self {
        self.textViewDelegate = textViewDelegate
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

// MARK: UITextView
public extension UITextView {
    var formTextView: TextView? {
        var superview: UIView? = self
        while superview != nil {
            superview = superview?.superview
            guard let textView = superview as? TextView else { continue }
            return textView
        }
        return nil
    }
}
