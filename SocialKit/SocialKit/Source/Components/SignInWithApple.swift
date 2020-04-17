//
//  SignInWithApple.swift
//  SocialKit
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import AuthenticationServices
import Forms
import UIKit

// MARK: SignInWithApple
open class SignInWithApple: FormComponent, Clickable {
    public let backgroundView = UIView()
        .with(isUserInteractionEnabled: true)
    public lazy var signInWithApple: ASAuthorizationAppleIDButton = self.signInWithAppleWhite
    private lazy var signInWithAppleDark: ASAuthorizationAppleIDButton = {
        let signInWithApple = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        signInWithApple.addTarget(self, action: #selector(handleSignInWithApple), for: .touchUpInside)
        return signInWithApple
    }()
    private lazy var signInWithAppleWhite: ASAuthorizationAppleIDButton = {
        let signInWithApple = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        signInWithApple.addTarget(self, action: #selector(handleSignInWithApple), for: .touchUpInside)
        return signInWithApple
    }()
    
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    open var edgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateEdgeInset() }
    }
    open var height: CGFloat = UITableView.automaticDimension
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    
    public var onClick: (() -> Void)? = nil
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupSignInWithApple()
        super.setupView()
    }
    
    override open func setTheme() {
        super.setTheme()
        self.setupSignInWithApple()
    }
    
    override open func enable(animated: Bool) {
        self.signInWithApple.isEnabled = true
    }
    
    override open func disable(animated: Bool) {
        self.signInWithApple.isEnabled = false
    }
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
    
    @objc
    private func handleSignInWithApple(_ sender: ASAuthorizationAppleIDButton) {
        self.onClick?()
    }
    
    private func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    private func setupSignInWithApple() {
        let edgeInset: UIEdgeInsets = self.paddingEdgeInset
        self.signInWithApple.removeFromSuperview()
        self.signInWithApple = self.traitCollection.userInterfaceStyle == .dark
            ? self.signInWithAppleDark
            : self.signInWithAppleWhite
        self.signInWithApple.frame = self.bounds
        self.signInWithApple.constraint(to: self.signInWithApple, position: .width, relation: .lessThanOrEqual)?.priority = .defaultHigh
        self.backgroundView.addSubview(self.signInWithApple, with: [
            Anchor.to(self.backgroundView).top.offset(edgeInset.top),
            Anchor.to(self.backgroundView).bottom.offset(edgeInset.bottom),
            Anchor.to(self.backgroundView).leading.offset(edgeInset.leading),
            Anchor.to(self.backgroundView).trailing.offset(edgeInset.trailing)
        ])
    }
    
    private func updateEdgeInset() {
        let edgeInset: UIEdgeInsets = self.edgeInset
        self.backgroundView.frame = self.bounds.with(inset: edgeInset)
        self.backgroundView.constraint(to: self, position: .top)?.constant = edgeInset.top
        self.backgroundView.constraint(to: self, position: .bottom)?.constant = -edgeInset.bottom
        self.backgroundView.constraint(to: self, position: .leading)?.constant = edgeInset.leading
        self.backgroundView.constraint(to: self, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    private func updatePaddingEdgeInset() {
        let edgeInset: UIEdgeInsets = self.paddingEdgeInset
        self.signInWithApple.frame = self.bounds.with(inset: edgeInset)
        self.signInWithApple.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.signInWithApple.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.signInWithApple.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.signInWithApple.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
}

// MARK: Builder
public extension SignInWithApple { 
    func with(edgeInset: UIEdgeInsets) -> Self {
        self.edgeInset = edgeInset
        return self
    }
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(paddingEdgeInset: UIEdgeInsets) -> Self {
        self.paddingEdgeInset = paddingEdgeInset
        return self
    }
}
