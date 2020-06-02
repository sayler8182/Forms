//
//  SignInWithGoogle.swift
//  FormsSocialKit
//
//  Created by Konrad on 4/17/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

#if canImport(GoogleSignIn)

import AppAuth
import Forms
import FormsAnchor
import GoogleSignIn
import GTMAppAuth
import GTMSessionFetcher
import UIKit

// MARK: SignInWithGoogle
open class SignInWithGoogle: FormsComponent, Clickable, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
        .with(isUserInteractionEnabled: true)
    public let signInWithGoogle = UIButton()
        .with(backgroundColor: UIColor(0xDF4930))
        .with(cornerRadius: 6)
        .with(titleColor: UIColor.white)
        .with(titleFont: Theme.Fonts.regular(ofSize: 12))
    
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var height: CGFloat = UITableView.automaticDimension
    open var title: String? {
        get { return self.signInWithGoogle.title(for: .normal) }
        set { self.signInWithGoogle.setTitle(newValue, for: .normal) }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    
    public var onClick: (() -> Void)? = nil
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupSignInWithGoogle()
        super.setupView()
    }
    
    override open func setupActions() {
        super.setupActions()
        self.signInWithGoogle.addTarget(self, action: #selector(handleSignInWithGoogle), for: .touchUpInside)
    }
    
    override open func enable(animated: Bool) {
        self.signInWithGoogle.isEnabled = true
    }
    
    override open func disable(animated: Bool) {
        self.signInWithGoogle.isEnabled = false
    }
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
    
    @objc
    private func handleSignInWithGoogle(_ sender: UIButton) {
        self.onClick?()
    }
    
    private func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    private func setupSignInWithGoogle() {
        self.signInWithGoogle.frame = self.bounds
        self.backgroundView.addSubview(self.signInWithGoogle, with: [
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
        self.signInWithGoogle.frame = self.bounds.with(inset: edgeInset)
        self.signInWithGoogle.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.signInWithGoogle.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.signInWithGoogle.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.signInWithGoogle.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
}

// MARK: Builder
public extension SignInWithGoogle {
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