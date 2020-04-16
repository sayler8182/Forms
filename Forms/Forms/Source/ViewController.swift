//
//  ViewController.swift
//  Forms
//
//  Created by Konrad on 4/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: ViewController
open class ViewController: UIViewController, UIGestureRecognizerDelegate {
    public var bottomAnchor: AnchorConnection = AnchorConnection()
    open var resizeOnKeybord: Bool = true
    
    open var isShimmering: Bool {
        return self.view.isShimmering
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    deinit {
        print("Deinit \(type(of: self))")
    }
    
    open func setupView() {
        self.setupConfiguration()
        self.setupResizerOnKeyboard()
        self.setupKeyboardWhenTappedAround()
        self.setupSlideToPop()
        
        // HOOKS
        self.setupNavigationBar()
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
    open func setupConfiguration() {
        // HOOK
    }
    
    open func setupNavigationBar() {
        // HOOK
    }
    
    open func setupContent() {
        self.view.backgroundColor = UIColor.systemBackground
        // HOOK
    }
    
    open func setupActions() {
        // HOOK
    }
    
    open func setupOther() {
        // HOOK
    }
}

// MARK: ViewController
public extension ViewController {
    func setNavigationBar(_ navigationBar: NavigationBar) {
        navigationBar.setNavigationBar(self.navigationController?.navigationBar)
        navigationBar.setNavigationItem(self.navigationItem)
    }
}

// MARK: Keyboard
public extension ViewController {
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
public extension ViewController {
    func setupSlideToPop() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
