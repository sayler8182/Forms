//
//  FormsViewController.swift
//  Forms
//
//  Created by Konrad on 4/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsInjector
import FormsLogger
import FormsUtils
import FormsUtilsUI
import FormsValidators
import UIKit

// MARK: FormsViewController
open class FormsViewController: UIViewController, UIGestureRecognizerDelegate, AppLifecycleable, Themeable, NavigationBarRefreshable {
    public lazy var keyboard = Keyboard()
    private var navigationBar: NavigationBar? = nil
    private var navigationProgressBar: ProgressBar? = nil
    private var backgroundView: UIView? = nil
    private var searchController: UISearchController? = nil
    
    public var onValidate: Validable.OnValidate?
    
    open var bottomAnchor: AnchorConnection = AnchorConnection()
    open var centerYAnchor: AnchorConnection = AnchorConnection()
    open var isResizeOnKeyboard: Bool = true
    open var isShimmering: Bool {
        return self.view.isShimmering
    }
    open var isThemeAutoRegister: Bool {
        return true
    }
    open var appLifecycleableEvents: [AppLifecycleEvent] {
        return []
    }
    
    open var additionalTopSafeArea: CGFloat {
        guard !self.preventAdditionalSafeArea else { return 0 }
        return [
            self.navigationProgressBar?.height
            ]
            .compactMap { $0 }
            .reduce(0, +)
    }
    open var preventAdditionalSafeArea: Bool = false
    
    override public init(nibName nibNameOrNil: String?,
                         bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.postInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.postInit()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    deinit {
        self.unregisterAppLifecycle()
        let logger: Logger? = Injector.main.resolveOrDefault("Forms")
        logger?.log(LogType.info, "Deinit \(type(of: self))")
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBar?.updateProgress(animated: animated)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupSlideToPop()
        self.navigationBar?.updateProgress(animated: animated)
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.Colors.statusBar.style
    }
    
    open func setupView() {
        self.setupConfiguration()
        self.setupResizerOnKeyboard()
        self.setupKeyboardWhenTappedAround()
        self.setupTheme()
        
        // HOOKS
        self.setupNavigationBar()
        self.setupSearchBar()
        self.setupContent()
        self.setupActions()
        self.setupOther()
        self.setupMock()
    }
    
    public func startShimmering(animated: Bool = true) {
        self.view.startShimmering(animated: animated)
    }
    
    public func stopShimmering(animated: Bool = true) {
        self.view.stopShimmering(animated: animated)
    }
    
    public func startLoading(_ view: Loadingable,
                             animated: Bool = true) {
        self.disable()
        view.startLoading(animated: animated)
    }
    
    public func stopLoading(_ view: Loadingable,
                            animated: Bool = true) {
        view.stopLoading(animated: animated)
        self.enable()
    }
    
    open func setTheme() {
        self.setNeedsStatusBarAppearanceUpdate()
        self.view.backgroundColor = Theme.Colors.primaryLight  
        self.view.flatSubviews
            .compactMap { $0 as? Themeable }
            .forEach { $0.setTheme() }
    }
    
    open func appLifecycleable(event: AppLifecycleEvent) { }
    
    // MARK: HOOKS
    open func postInit() {
        self.registerAppLifecycle()
        // HOOK
    }
    
    open func setupConfiguration() {
        // HOOK
    }
    
    open func setupResizerOnKeyboard() {
        guard self.isResizeOnKeyboard else { return }
        self.registerKeyboard()
        self.keyboard.onUpdate = Strong(self) { (_self, percent, visibleHeight, animated) in
            _self.updateKeyboard(percent, visibleHeight, animated)
        }
    }
    
    open func setupTheme() {
        self.setTheme()
        guard self.isThemeAutoRegister else { return }
        Theme.register(self)
        // HOOK
    }
    
    open func setupNavigationBar() {
        // HOOK
    }
    
    open func setupSearchBar() {
        // HOOK
    }
    
    open func setupContent() {
        // HOOK
    }
    
    open func setupActions() {
        // HOOK
    }
    
    open func setupOther() {
        // HOOK
    }
    
    open func updateSafeArea() {
        // HOOK
    }
    
    @objc
    open dynamic func setupMock() {
        // HOOK
    }
}

// MARK: Validators
extension FormsViewController {
    @objc
    public func triggerValidators() {
        let items: [Validable] = self.view.flatSubviews.compactMap { $0 as? Validable }
        for item in items {
            item.validatorTriggered = true
        }
    }
    
    @objc
    @discardableResult
    public func validateWithTrigger() -> Bool {
        self.triggerValidators()
        return self.validate()
    }
    
    @objc
    @discardableResult
    public func validate() -> Bool {
        return self.validate(false)
    }
    
    @objc
    @discardableResult
    open func validate(_ isSilence: Bool) -> Bool {
        var result: Bool = true
        let items: [Validable] = self.view.flatSubviews.compactMap { $0 as? Validable }
        for item in items {
            result = item.validate(isSilence) && result
        }
        if !isSilence {
            self.onValidate?(result)
        }
        return result
    }
}

// MARK: BackgroundView
public extension FormsViewController {
    func setBackgroundView(_ view: UIView?) {
        self.backgroundView?.removeFromSuperview()
        guard let view: UIView = view else { return }
        self.view.insertSubview(view, at: 0)
        view.anchors([
            Anchor.to(self.view).fill
        ])
        self.backgroundView = view
    }
}

// MARK: NavigationBar
public extension FormsViewController {
    func setNavigationBar(_ navigationBar: NavigationBar,
                          animated: Bool = true) {
        self.navigationBar = navigationBar
        navigationBar.setNavigationBar(self.navigationController?.navigationBar)
        navigationBar.setNavigationItem(self.navigationItem)
        navigationBar.updateProgress(animated: animated)
    }
    
    func refreshNavigationBar() {
        self.navigationBar?.setNavigationBar(self.navigationController?.navigationBar)
        self.navigationBar?.setNavigationItem(self.navigationItem)
    }
}

// MARK: NavigationBar
public extension FormsViewController {
    func setNavigationProgressBar(_ progressBar: ProgressBar) {
        self.navigationProgressBar = progressBar
        self.view.addSubview(progressBar, with: [
            Anchor.to(self.view).top.safeArea,
            Anchor.to(self.view).horizontal
        ])
        self.updateSafeArea()
    }
}

// MARK: SearchBar
public extension FormsViewController {
    @objc
    func setSearchController(_ searchController: FormsSearchController) {
        self.setSearchBar(searchController)
        searchController.setTheme()
    }
    @objc
    func setSearchBar(_ searchController: UISearchController) {
        if #available(iOS 11.0, *) {
            self.navigationItem.hidesSearchBarWhenScrolling = false
            self.navigationItem.searchController = searchController
        }
    }
}

// MARK: Keyboard
public extension FormsViewController {
    func registerKeyboard() {
        self.keyboard.register()
    }
    
    func unregisterKeyboard() {
        self.keyboard.unregister()
    }
    
    func updateKeyboard(_ percent: CGFloat,
                        _ visibleHeight: CGFloat,
                        _ animated: Bool) {
        guard self.bottomAnchor.constraint.isNotNil || self.centerYAnchor.constraint.isNotNil else { return }
        let viewHeight: CGFloat = self.view.frame.height
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let safeAreaInset: CGFloat = UIView.safeArea.bottom
        let time: CGFloat = (visibleHeight - screenHeight + viewHeight - safeAreaInset) / visibleHeight * 0.2
        if let constraint: NSLayoutConstraint = self.bottomAnchor.constraint {
            constraint.constant = visibleHeight != 0.0
                ? -visibleHeight + safeAreaInset
                : -visibleHeight
        } else if let constraint: NSLayoutConstraint = self.centerYAnchor.constraint {
            constraint.constant = visibleHeight != 0.0
                ? (-visibleHeight + safeAreaInset) / 2
                : (-visibleHeight) / 2
        }
        self.view.animation(
            animated,
            duration: time.asDouble,
            animations: self.view.layoutIfNeeded)
    }
}

// MARK: Slide to pop
public extension FormsViewController {
    func setupSlideToPop() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}
