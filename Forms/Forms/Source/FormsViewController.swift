//
//  FormsViewController.swift
//  Forms
//
//  Created by Konrad on 4/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import UIKit

// MARK: FormsViewController
open class FormsViewController: UIViewController, UIGestureRecognizerDelegate {
    private var navigationBar: NavigationBar? = nil
    private var navigationProgressBar: ProgressBar? = nil
    private var searchController: UISearchController? = nil
    
    open var bottomAnchor: AnchorConnection = AnchorConnection()
    open var resizeOnKeybord: Bool = true
    
    open var isShimmering: Bool {
        return self.view.isShimmering
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
        print("Deinit \(type(of: self))")
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
    
    open func setupView() {
        self.setupConfiguration()
        self.setupResizerOnKeyboard()
        self.setupKeyboardWhenTappedAround()
        
        // HOOKS
        self.setupNavigationBar()
        self.setupSearchBar()
        self.setupContent()
        self.setupActions()
        self.setupOther()
    }
    
    public func startShimmering(animated: Bool = true) {
        self.view.startShimmering(animated: animated)
    }
    
    public func stopShimmering(animated: Bool = true) {
        self.view.stopShimmering(animated: animated)
    }
    
    // MARK: HOOKS
    open func postInit() {
        // HOOK
    }
    
    open func setupConfiguration() {
        // HOOK
    }
    
    open func setupNavigationBar() {
        // HOOK
    }
    
    open func setupSearchBar() {
        // HOOK
    }
    
    open func setupContent() {
        self.view.backgroundColor = Theme.systemBackground
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
    func setSearchBar(_ searchController: UISearchController) {
        if #available(iOS 11.0, *) {
            self.navigationItem.hidesSearchBarWhenScrolling = false
            self.navigationItem.searchController = searchController
        }
    }
}

// MARK: Keyboard
public extension FormsViewController {
    func setupResizerOnKeyboard() {
        guard self.resizeOnKeybord else { return }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboarWillShowForResizing),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboarWillHideForResizing),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    func removeKeyboardForResizing() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboarWillShowForResizing(notification: Notification) {
        guard let constraint: NSLayoutConstraint = self.bottomAnchor.constraint else { return }
        let keyboardFrame: NSValue? = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let keyboardHeight: CGFloat = keyboardFrame?.cgRectValue.height else { return }
        let viewHeight: CGFloat = self.view.frame.height
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let safeAreaInset: CGFloat = UIView.safeArea.bottom
        let y: CGFloat = keyboardHeight - screenHeight + viewHeight - safeAreaInset
        guard y > 0 else { return }
        let time: Double = Double(y / keyboardHeight * 0.2)
        constraint.constant = -keyboardHeight + safeAreaInset
        UIView.animate(withDuration: time) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func keyboarWillHideForResizing(notification: Notification) {
        guard let constraint: NSLayoutConstraint = self.bottomAnchor.constraint else { return }
        let keyboardFrame: NSValue? = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let keyboardHeight: CGFloat = keyboardFrame?.cgRectValue.height else { return }
        let time: Double = Double(constraint.constant / keyboardHeight * 0.2)
        constraint.constant = 0
        UIView.animate(withDuration: time) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: Slide to pop
public extension FormsViewController {
    func setupSlideToPop() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
