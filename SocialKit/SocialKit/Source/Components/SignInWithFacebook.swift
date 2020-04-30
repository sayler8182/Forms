//
//  SignInWithFacebook.swift
//  SocialKit
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

#if canImport(FBSDKLoginKit)

import FBSDKCoreKit
import FBSDKLoginKit
import Forms
import UIKit

// MARK: SignInWithFacebook
open class SignInWithFacebook: FormsComponent, Clickable, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
        .with(isUserInteractionEnabled: true)
    public let signInWithFacebook = UIButton()
        .with(backgroundColor: UIColor(0x3B5998))
        .with(cornerRadius: 6)
        .with(titleColor: UIColor.white)
        .with(titleFont: UIFont.systemFont(ofSize: 12))
    
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var height: CGFloat = UITableView.automaticDimension
    open var title: String? {
        get { return self.signInWithFacebook.title(for: .normal) }
        set { self.signInWithFacebook.setTitle(newValue, for: .normal) }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    
    public var onClick: (() -> Void)? = nil
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupSignInWithFacebook()
        super.setupView()
    }
    
    override open func setupActions() {
        super.setupActions()
        self.signInWithFacebook.addTarget(self, action: #selector(handleSignInWithFacebook), for: .touchUpInside)
    }
    
    override open func enable(animated: Bool) {
        self.signInWithFacebook.isEnabled = true
    }
    
    override open func disable(animated: Bool) {
        self.signInWithFacebook.isEnabled = false
    }
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
    
    @objc
    private func handleSignInWithFacebook(_ sender: UIButton) {
        self.onClick?()
    }
    
    private func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    private func setupSignInWithFacebook() {
        self.signInWithFacebook.frame = self.bounds
        self.backgroundView.addSubview(self.signInWithFacebook, with: [
            Anchor.to(self.backgroundView).fill,
            Anchor.to(self.backgroundView).height(30)
        ])
    }
    
    private func updateMarginEdgeInset() {
        let edgeInset: UIEdgeInsets = self.marginEdgeInset
        self.backgroundView.frame = self.bounds.with(inset: edgeInset)
        self.backgroundView.constraint(to: self, position: .top)?.constant = edgeInset.top
        self.backgroundView.constraint(to: self, position: .bottom)?.constant = -edgeInset.bottom
        self.backgroundView.constraint(to: self, position: .leading)?.constant = edgeInset.leading
        self.backgroundView.constraint(to: self, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    private func updatePaddingEdgeInset() {
        let edgeInset: UIEdgeInsets = self.paddingEdgeInset
        self.signInWithFacebook.frame = self.bounds.with(inset: edgeInset)
        self.signInWithFacebook.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.signInWithFacebook.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.signInWithFacebook.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.signInWithFacebook.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
}

// MARK: Builder
public extension SignInWithFacebook {
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(title: String?) -> Self {
        self.title = title
        return self
    }
}

#endif
