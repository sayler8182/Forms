//
//  PinView.swift
//  Forms
//
//  Created by Konrad on 5/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsUtils
import FormsValidators
import UIKit

// MARK: State
public extension PinView {
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

// MARK: PinView
open class PinView: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
        .with(width: 320, height: 85)
        .with(isUserInteractionEnabled: true)
    public let titleLabel = UILabel()
        .with(width: 320, height: 20)
    public let textFieldContainer = UIStackView()
        .with(width: 320, height: 44)
    public var textFields: [UITextFieldWithPlaceholder] = []
    public let underscoreViewContainer = UIStackView()
        .with(width: 320, height: 2)
    public var underscoreViews: [UIView] = []
    public let errorLabel = UILabel()
        .with(width: 320, height: 20)
    public let infoLabel = UILabel()
        .with(width: 320, height: 20)
    private let gestureRecognizer = UITapGestureRecognizer()
    
    private var shouldSkipBeginEditing: Bool = false
    private var shouldSkipEndEditing: Bool = false
    
    open var animationTime: TimeInterval = 0.2
    open var autocapitalizationType: UITextAutocapitalizationType = .none {
        didSet { self.textFields.forEach { $0.autocapitalizationType = self.autocapitalizationType } }
    }
    open var autocorrectionType: UITextAutocorrectionType = .no {
        didSet { self.textFields.forEach { $0.autocorrectionType = self.autocorrectionType } }
    }
    open var backgroundColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryBackground) {
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
    open var isSecureTextEntry: Bool = false {
        didSet { self.textFields.forEach { $0.isSecureTextEntry = self.isSecureTextEntry } }
    }
    open var itemSpacing: CGFloat = 6.0 {
        didSet {
            self.textFieldContainer.spacing = self.itemSpacing
            self.underscoreViewContainer.spacing = self.itemSpacing
        }
    }
    open var itemWidth: CGFloat = 30.0 {
        didSet { self.textFields.forEach { $0.constraint(from: $0, position: .width)?.constant = self.itemWidth } }
    }
    open var keyboardType: UIKeyboardType = .numberPad {
        didSet { self.textFields.forEach { $0.keyboardType = self.keyboardType } }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var numberOfChars: Int = 4 {
        didSet { self.updateInput() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var placeholder: String? {
        didSet { self.updatePlaceholder() }
    }
    open var placeholderColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryText.withAlphaComponent(0.3)) {
        didSet { self.updateState() }
    }
    open var placeholderFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 32)) {
        didSet { self.updateState() }
    }
    private var _smartQuotesType: Any? = nil
    @available(iOS 11.0, *)
    open var smartQuotesType: UITextSmartQuotesType {
        get { return (self._smartQuotesType as? UITextSmartQuotesType) ?? .no }
        set {
            self.textFields.forEach { $0.smartQuotesType = newValue }
            self._smartQuotesType = newValue
        }
    }
    open var text: String? {
        get { return self.textFields.compactMap { $0.text }.joined() }
        set { self.setText(newValue) }
    }
    open var textAlignment: NSTextAlignment = .natural {
        didSet {
            self.titleLabel.textAlignment = self.textAlignment
            self.textFields.forEach { $0.textAlignment = self.textAlignment }
            self.errorLabel.textAlignment = self.textAlignment
            self.infoLabel.textAlignment = self.textAlignment
        }
    }
    open var textColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryText) {
        didSet { self.updateState() }
    }
    open var textFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 32)) {
        didSet { self.updateState() }
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
    open var underscoreColors: State<UIColor?> = State<UIColor?>(Theme.Colors.gray) {
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
        self.setupTextFieldContainer()
        self.setupUnderscoreViewContainer()
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
    private func handleGesture(recognizer: UITapGestureRecognizer) { }
    
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
    
    // MARK: Actions
    @objc
    private func handleOnBeginEditing(_ sender: UITextField) {
        self.updateState(animated: true)
        self.validatorTrigger()
        if let newText: String = self.formatText?(sender.text) {
            sender.text = newText
        }
        self.onBeginEditing?(self.text)
        if self.validateOnBeginEditing {
            self.validate()
            self.table?.refreshTableView()
        }
    }
    
    @objc
    private func handleOnEndEditing(_ sender: UITextField) {
        self.updateState(animated: true)
        self.validatorTrigger()
        self.onEndEditing?(self.text)
        if self.validateOnEndEditing {
            self.validate()
            self.table?.refreshTableView()
        }
    }
    
    @objc
    private func handleOnTextChanged(_ sender: UITextField) {
        self.validatorTrigger()
        self.onTextChanged?(self.text)
        if self.validateOnTextChange {
            self.validate()
            self.table?.refreshTableView()
        }
    }
    
    // MARK: HOOKS - setup
    open func setupBackgroundView() {
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).top,
            Anchor.to(self).horizontal,
            Anchor.to(self).bottom.greaterThanOrEqual
        ])
    }
    
    open func setupTitleLabel() {
        self.backgroundView.addSubview(self.titleLabel, with: [
            Anchor.to(self.backgroundView).top.offset(self.paddingEdgeInset.top),
            Anchor.to(self.backgroundView).leading.offset(self.paddingEdgeInset.leading),
            Anchor.to(self.backgroundView).trailing.offset(self.paddingEdgeInset.trailing)
        ])
    }
    
    open func setupTextFieldContainer() {
        self.textFieldContainer.axis = .horizontal
        self.textFieldContainer.spacing = self.itemSpacing
        self.backgroundView.addSubview(self.textFieldContainer, with: [
            Anchor.to(self.titleLabel).topToBottom.offset(2),
            Anchor.to(self.backgroundView).centerX,
            Anchor.to(self.backgroundView).leading.greaterThanOrEqual.offset(self.paddingEdgeInset.leading),
            Anchor.to(self.backgroundView).trailing.greaterThanOrEqual.offset(self.paddingEdgeInset.trailing)
        ])
    }
    
    open func setupUnderscoreViewContainer() {
        self.underscoreViewContainer.axis = .horizontal
        self.underscoreViewContainer.spacing = self.itemSpacing
        self.backgroundView.addSubview(self.underscoreViewContainer, with: [
            Anchor.to(self.textFieldContainer).topToBottom.offset(2),
            Anchor.to(self.backgroundView).centerX,
            Anchor.to(self.backgroundView).leading.greaterThanOrEqual.offset(self.paddingEdgeInset.leading),
            Anchor.to(self.backgroundView).trailing.greaterThanOrEqual.offset(self.paddingEdgeInset.trailing),
            Anchor.to(self.underscoreViewContainer).height(2.0)
        ])
    }
    
    open func setupErrorLabel() {
        self.errorLabel.numberOfLines = 0
        self.backgroundView.addSubview(self.errorLabel, with: [
            Anchor.to(self.underscoreViewContainer).topToBottom.offset(2),
            Anchor.to(self.backgroundView).leading.offset(self.paddingEdgeInset.leading),
            Anchor.to(self.backgroundView).trailing.offset(self.paddingEdgeInset.trailing)
        ])
    }
    
    open func setupInfoLabel() {
        self.infoLabel.numberOfLines = 0
        self.backgroundView.addSubview(self.infoLabel, with: [
            Anchor.to(self.errorLabel).topToBottom,
            Anchor.to(self.backgroundView).leading.offset(self.paddingEdgeInset.leading),
            Anchor.to(self.backgroundView).trailing.offset(self.paddingEdgeInset.trailing),
            Anchor.to(self.backgroundView).bottom.offset(self.paddingEdgeInset.bottom).priority(.defaultHigh)
        ])
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
    
    open func updateInput() {
        self.textFieldContainer.removeArrangedSubviews()
        self.textFields.removeAll()
        self.underscoreViewContainer.removeArrangedSubviews()
        self.underscoreViews.removeAll()
        for i in 0..<self.numberOfChars {
            let textField = UITextFieldWithPlaceholder()
            textField.tag = i
            textField.delegate = self
            textField.autocapitalizationType = self.autocapitalizationType
            textField.autocorrectionType = self.autocorrectionType
            textField.isSecureTextEntry = self.isSecureTextEntry
            textField.keyboardType = self.keyboardType
            textField.textAlignment = self.textAlignment
            if #available(iOS 11.0, *) {
                textField.smartQuotesType = self.smartQuotesType
            }
            textField.onDeleteBackward = Unowned(self) { (_self) in
                _ = _self.textField(textField, shouldChangeCharactersIn: NSRange(), replacementString: "")
            }
            self.textFieldContainer.addArrangedSubview(textField)
            textField.anchors([
                Anchor.to(textField).width(self.itemWidth)
            ])
            self.textFields.append(textField)
            let underscoreView = UIView()
            underscoreView.tag = i
            self.underscoreViewContainer.addArrangedSubview(underscoreView)
            underscoreView.anchors([
                Anchor.to(textField).width
            ])
            self.underscoreViews.append(underscoreView)
        }
        self.setText(self.text)
        self.setState(self.state, animated: false, force: true)
    }
    
    open func updatePaddingEdgeInset() {
        let edgeInset: UIEdgeInsets = self.paddingEdgeInset
        self.titleLabel.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.titleLabel.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.titleLabel.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.textFieldContainer.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.textFieldContainer.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.underscoreViewContainer.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.underscoreViewContainer.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.errorLabel.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.errorLabel.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.infoLabel.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.infoLabel.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.infoLabel.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
    }
    
    open func updatePlaceholder() {
        for (i, textField) in self.textFields.enumerated() {
            textField.placeholder = self.placeholder?[i]
        }
    }
    
    private func updateState(animated: Bool) {
        if self.error.isNotNilOrEmpty {
            self.setState(.error, animated: animated)
        } else if !self.isEnabled {
            self.setState(.disabled, animated: animated)
        } else if self.textFieldContainer.isFirstResponder {
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
    
    private func setText(_ text: String?) {
        for (i, textField) in self.textFields.enumerated() {
            textField.text = text?[i]
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
            self.textFields.forEach {
                $0.textColor = self.textColors.value(for: state)
                $0.font = self.textFonts.value(for: state)
                $0.placeholderColor = self.placeholderColors.value(for: state)
                $0.placeholderFont = self.placeholderFonts.value(for: state)
            }
            self.titleLabel.textColor = self.titleColors.value(for: state)
            self.titleLabel.font = self.titleFonts.value(for: state)
            self.underscoreViews.forEach {
                $0.backgroundColor = self.underscoreColors.value(for: state)
            }
        }
        self.state = state
    }
}

// MARK: Validable
extension PinView: Validable {
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
extension PinView: Inputable {
    public var focusedTextField: UITextField? {
        return self.textFields.first(where: { $0.isFirstResponder })
    }
    
    public var firstEmptyTextField: UITextField? {
        return self.textFields.first(where: { $0.text.isNilOrEmpty })
    }
    
    public func textField(for index: Int?) -> UITextField? {
        guard let index: Int = index else { return nil }
        return self.textFields[safe: index]
    }
    
    public func focus(animated: Bool) {
        guard self.focusedTextField.isNil else { return }
        guard let textField: UITextField = self.firstEmptyTextField else { return }
        self.textFieldFocus(textField, isSkipping: false)
    }
    
    public func lostFocus(animated: Bool) {
        guard self.focusedTextField.isNotNil else { return }
        guard let textField: UITextField = self.focusedTextField else { return }
        self.textFieldLostFocus(textField)
    }
}

// MARK: UITextFieldDelegate
extension PinView: UITextFieldDelegate {
    public func textFieldDidPaste(_ textField: UITextField,
                                  string: String) -> Bool {
        return true
    }
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        guard !self.textFieldUpdatePaste(textField, string) else { return false }
        guard !self.textFieldUpdateBack(textField, string) else { return false }
        guard !self.textFieldUpdateNext(textField, string) else { return false }
        return false
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.focusedTextField.isNil {
            DispatchQueue.main.async {
                self.handleOnBeginEditing(textField)
            }
        }
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.shouldSkipEndEditing = false
        if !self.shouldSkipBeginEditing {
            self.handleOnBeginEditing(textField)
            self.shouldSkipBeginEditing = false
        }
        DispatchQueue.main.async {
            textField.setEndTextFocus()
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.shouldSkipBeginEditing = false
        if !self.shouldSkipEndEditing {
            self.handleOnEndEditing(textField)
            self.shouldSkipEndEditing = false
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.lostFocus()
        return true
    }
    
    private func textFieldUpdateBack(_ textField: UITextField,
                                     _ string: String) -> Bool {
        guard string.isEmpty else { return false }
        if let prevTextField: UITextField = self.textFields.reversed()
            .first(where: { $0.text.isNotNilOrEmpty && $0.tag <= textField.tag }) {
            textField.text = string
            self.handleOnTextChanged(textField)
            if prevTextField.tag != textField.tag {
                self.textFieldFocus(prevTextField)
            }
        } else if textField.tag != 0 {
            textField.text = string
            self.handleOnTextChanged(textField)
            if let firstTextField: UITextField = self.textFields[safe: 0] {
                self.textFieldFocus(firstTextField)
            } else {
                self.textFieldLostFocus(textField)
            }
        } else {
            textField.text = string
            self.handleOnTextChanged(textField)
            self.textFieldLostFocus(textField)
        }
        return true
    }
    
    private func textFieldUpdatePaste(_ textField: UITextField,
                                      _ string: String) -> Bool {
        guard string.count > 1 else { return false }
        let index: Int = textField.tag
        for i in 0..<string.count {
            guard let textField: UITextField = self.textField(for: index + i) else { break }
            textField.text = string[i]
        }
        self.handleOnTextChanged(textField)
        if let nextTextField: UITextField = self.textFields.reversed()
            .first(where: { $0.text.isNilOrEmpty && $0.tag > textField.tag }) {
            self.textFieldFocus(nextTextField)
        } else {
            self.textFieldLostFocus(textField)
        }
        return true
    }
    
    private func textFieldUpdateNext(_ textField: UITextField,
                                     _ string: String) -> Bool {
        textField.text = string
        self.handleOnTextChanged(textField)
        if let nextTextField: UITextField = self.textFields.first(where: { $0.text.isNilOrEmpty && $0.tag > textField.tag }) {
            self.textFieldFocus(nextTextField)
        } else {
            self.textFieldLostFocus(textField)
        }
        return true
    }
    
    private func textFieldFocus(_ textField: UITextField,
                                isSkipping: Bool = true) {
        self.shouldSkipBeginEditing = isSkipping
        self.shouldSkipEndEditing = isSkipping
        textField.becomeFirstResponder()
    }
    
    private func textFieldLostFocus(_ textField: UITextField,
                                    isSkipping: Bool = false) {
        self.shouldSkipBeginEditing = isSkipping
        self.shouldSkipEndEditing = isSkipping
        textField.resignFirstResponder()
    }
}

// MARK: Builder
public extension PinView {
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
    func with(itemSpacing: CGFloat) -> Self {
        self.itemSpacing = itemSpacing
        return self
    }
    func with(itemWidth: CGFloat) -> Self {
        self.itemWidth = itemWidth
        return self
    }
    func with(keyboardType: UIKeyboardType) -> Self {
        self.keyboardType = keyboardType
        return self
    }
    func with(numberOfChars: Int) -> Self {
        self.numberOfChars = numberOfChars
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
    func with(textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
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

// MARK: UITextField
public extension PinView {
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
