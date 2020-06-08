//
//  FormsSearchController.swift
//  Forms
//
//  Created by Konrad on 4/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsInjector
import FormsLogger
import FormsUtils
import FormsValidators
import UIKit

// MARK: State
public extension FormsSearchController {
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

// MARK: FormsSearchController
open class FormsSearchController: UISearchController, AppLifecycleable, Themeable {
    open var animationTime: TimeInterval = 0.2
    open var autocapitalizationType: UITextAutocapitalizationType {
        get { return self.searchBar.autocapitalizationType }
        set { self.searchBar.autocapitalizationType = newValue }
    }
    open var autocorrectionType: UITextAutocorrectionType {
        get { return self.searchBar.autocorrectionType }
        set { self.searchBar.autocorrectionType = newValue }
    }
    open var keyboardType: UIKeyboardType {
        get { return self.searchBar.keyboardType }
        set { self.searchBar.keyboardType = newValue }
    }
    open var placeholder: String? {
        get { return self.searchBar.placeholder }
        set { self.searchBar.placeholder = newValue }
    }
    @available(iOS 11.0, *)
    open var smartQuotesType: UITextSmartQuotesType {
        get { return self.searchBar.smartQuotesType }
        set { self.searchBar.smartQuotesType = newValue }
    }
    open var text: String? {
        get { return self.searchBar.text }
        set { self.searchBar.text = newValue }
    }
    open var textColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryText) {
        didSet { self.updateState() }
    }
    private var _textFieldDelegate: UITextFieldDelegate? // swiftlint:disable:this weak_delegate
    open var textFieldDelegate: UITextFieldDelegate? {
        get { return self._textFieldDelegate }
        set {
            self._textFieldDelegate = newValue
            self.searchBar.textField.delegate = newValue
        }
    }
    open var textFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 14)) {
        didSet { self.updateState() }
    }
    
    open var isThemeAutoRegister: Bool {
        return true
    }
    
    open var appLifecycleableEvents: [AppLifecycleEvent] {
        return []
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
    
    public convenience init(_ updater: SearchUpdater) {
        self.init(searchResultsController: nil)
        updater.searchController = self
        self.searchResultsUpdater = updater
    }
    
    override public init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        self.postInit()
        self.setupSearchBar()
    }
    
    override public init(nibName nibNameOrNil: String?,
                         bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.postInit()
        self.setupSearchBar()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.postInit()
        self.setupSearchBar()
    }
    
    deinit {
        self.unregisterAppLifecycle()
        let logger: LoggerProtocol? = Injector.main.resolveOrDefault("Forms")
        logger?.log(.info, "Deinit \(type(of: self))")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    open func setupView() {
        self.setupConfiguration()
        self.setupTheme()
        self.setupContent()
        self.setupActions()
        self.setupOther()
    }
    
    open func setTheme() {
        self.textColors = State<UIColor?>(Theme.Colors.primaryText)
        self.textFonts = State<UIFont>(Theme.Fonts.regular(ofSize: 14))
    }
    
    open func appLifecycleable(event: AppLifecycleEvent) { }
    
    public func textFieldDelegate<T: UITextFieldDelegate>(of type: T.Type) -> T? {
        return self._textFieldDelegate as? T
    }
    
    // MARK: HOOKS
    open func postInit() {
        self.registerAppLifecycle()
        // HOOK
    }
    
    open func setupConfiguration() {
        // HOOK
    }
    
    open func setupTheme() {
        self.setTheme()
        guard self.isThemeAutoRegister else { return }
        Theme.register(self)
        // HOOK
    }
    
    open func setupContent() {
        self.obscuresBackgroundDuringPresentation = false
        self.view.backgroundColor = UIColor.clear
        // HOOK
    }
    
    open func setupSearchBar() {
        self.searchBar.backgroundImage = UIImage()
        self.updateState()
    }
    
    open func setupActions() {
        self.searchBar.textField.addTarget(self, action: #selector(handleOnBeginEditing), for: .editingDidBegin)
        self.searchBar.textField.addTarget(self, action: #selector(handleOnEndEditing), for: .editingDidEnd)
        self.searchBar.textField.addTarget(self, action: #selector(handleOnTextChanged), for: .editingChanged)
    }
    
    open func setupOther() {
        // HOOK
    }
}

// MARK: State
private extension FormsSearchController {
    func updateState(animated: Bool) {
        if self.isActive {
            self.setState(.disabled, animated: animated)
        } else if self.isFirstResponder {
            self.setState(.selected, animated: animated)
        } else {
            self.setState(.active, animated: animated)
        }
    }
    
    func updateState() {
        switch self.state {
        case .active: self.setState(.active, animated: false, force: true)
        case .selected: self.setState(.selected, animated: false, force: true)
        case .disabled: self.setState(.disabled, animated: false, force: true)
        }
    }
    
    func setState(_ state: StateType,
                  animated: Bool,
                  force: Bool = false) {
        guard self.state != state || force else { return }
        self.searchBar.animation(animated, duration: self.animationTime) {
            self.searchBar.textField?.textColor = self.textColors.value(for: state)
            self.searchBar.textField?.font = self.textFonts.value(for: state)
        }
        self.state = state
    }
}

// MARK: Actions
extension FormsSearchController {
    @objc
    func handleOnBeginEditing(_ sender: UITextField) {
        self.updateState(animated: true)
        self.validatorTrigger()
        if let newText: String = self.formatText?(sender.text) {
            sender.text = newText
        }
        self.onBeginEditing?(sender.text)
        if self.validateOnBeginEditing {
            self.validate()
        }
    }
    
    @objc
    func handleOnDidPaste(_ sender: UITextField) {
        self.validatorTrigger()
        self.onDidPaste?(sender.text)
    }
    
    @objc
    func handleOnEndEditing(_ sender: UITextField) {
        self.updateState(animated: true)
        self.validatorTrigger()
        self.onEndEditing?(sender.text)
        if self.validateOnEndEditing {
            self.validate()
        }
    }
    
    @objc
    func handleOnTextChanged(_ sender: UITextField) {
        self.validatorTrigger()
        self.onTextChanged?(sender.text)
        if self.validateOnTextChange {
            self.validate()
        }
    }
}

// MARK: Validable
extension FormsSearchController: Validable {
    public func validate(_ validator: Validator,
                         _ isSilence: Bool) -> Bool {
        return validator.validate(self.text).isValid
    }
}

// MARK: Inputable
extension FormsSearchController: Inputable {
    public func focus(animated: Bool) {
        self.searchBar.becomeFirstResponder()
    }
    
    public func lostFocus(animated: Bool) {
        self.searchBar.resignFirstResponder()
    }
}

// MARK: Builder
public extension FormsSearchController {
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
    func with(isActive: Bool) -> Self {
        self.isActive = isActive
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
