//
//  DemoSocialKitFacebookTableViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import SocialKit
import UIKit

// MARK: DemoSocialKitFacebookTableViewController
class DemoSocialKitFacebookTableViewController: FormsTableViewController {
    private let signInWithFacebook = Components.social.signInWithFacebook()
        .with(padding: 16)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    private lazy var signInWithFacebookProvider = SignInWithFacebookProvider(context: self)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.signInWithFacebook
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.signInWithFacebook.onClick = { [unowned self] in
            self.signInWithFacebookAuthorization()
        }
    }
}

// MARK: SignInWithFacebook
extension DemoSocialKitFacebookTableViewController {
    func signInWithFacebookAuthorization() {
        self.signInWithFacebookProvider.authorization(
            onSuccess: { [weak self] (data) in
                guard let `self` = self else { return }
                UIAlertController()
                    .with(title: "Sign in with Facebook")
                    .with(message: "data: \(data)")
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
