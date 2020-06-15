//
//  DemoSocialKitGoogleTableViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/17/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsSocialKit
import FormsToastKit
import FormsUtils
import UIKit

// MARK: DemoSocialKitGoogleTableViewController
class DemoSocialKitGoogleTableViewController: FormsTableViewController {
    private let signInWithGoogle = Components.social.signInWithGoogle()
        .with(margin: 16)

    private let divider = Components.utils.divider()
        .with(height: 5.0)

    private lazy var signInWithGoogleProvider = DemoSignInWithGoogleProvider(context: self)

    override func setupContent() {
        super.setupContent()
        self.build([
            self.signInWithGoogle
        ], divider: self.divider)
    }

    override func setupActions() {
        super.setupActions()
        self.signInWithGoogle.onClick = Unowned(self) { (_self) in
            _self.signInWithGoogleAuthorization()
        }
    }
}

// MARK: SignInWithGoogle
extension DemoSocialKitGoogleTableViewController {
    func signInWithGoogleAuthorization() {
        self.signInWithGoogle.startLoading()
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
            }, onCompletion: { [weak self] (_, _) in
                guard let `self` = self else { return }
                self.signInWithGoogle.stopLoading()
        })
    }
}
