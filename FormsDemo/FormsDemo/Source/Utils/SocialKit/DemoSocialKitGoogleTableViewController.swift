//
//  DemoSocialKitGoogleTableViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/17/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

#if canImport(SocialKit) && canImport(GoogleSignIn)

import Forms
import SocialKit
import UIKit

// MARK: DemoSocialKitGoogleTableViewController
class DemoSocialKitGoogleTableViewController: TableViewController {
    private let signInWithGoogle = Components.social.signInWithGoogle()
        .with(paddingEdgeInset: UIEdgeInsets(16))

    private let divider = Components.utils.divider()
        .with(height: 5.0)

    private lazy var signInWithGoogleProvider = SignInWithGoogleProvider(context: self)

    override func setupContent() {
        super.setupContent()
        self.build([
            self.signInWithGoogle
        ], divider: self.divider)
    }

    override func setupActions() {
        super.setupActions()
        self.signInWithGoogle.onClick = { [unowned self] in
            self.signInWithGoogleAuthorization()
        }
    }
}

// MARK: SignInWithApple
extension DemoSocialKitGoogleTableViewController {
    func signInWithGoogleAuthorization() {
        self.signInWithGoogleProvider.authorization(
            onSuccess: { [weak self] (data) in
                guard let `self` = self else { return }
                UIAlertController()
                    .with(title: "Sign in with Google")
                    .with(message: "authenticationToken: \(data.authenticationToken)")
                    .with(action: "Ok")
                    .present(on: self)
            }, onError: { [weak self] (error) in
                guard let `self` = self else { return }
                Toast.error()
                    .with(title: error.localizedDescription)
                    .show(in: self.navigationController)
        })
    }
}
 
#endif
