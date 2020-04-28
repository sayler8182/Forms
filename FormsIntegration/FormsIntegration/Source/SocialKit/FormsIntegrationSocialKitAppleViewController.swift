//
//  FormsIntegrationSocialKitAppleViewController.swift
//  FormsIntegration
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import SocialKit
import UIKit

// MARK: FormsIntegrationSocialKitAppleViewController
class FormsIntegrationSocialKitAppleViewController: FormsTableViewController {
    private let signInWithApple = Components.social.signInWithApple()
        .with(padding: 16)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    private lazy var signInWithAppleProvider = SignInWithAppleProvider(context: self)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.signInWithApple
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.signInWithApple.onClick = { [unowned self] in
            self.signInWithAppleAuthorization()
        }
    }
}

// MARK: SignInWithApple
extension FormsIntegrationSocialKitAppleViewController {
    func signInWithAppleAuthorization() {
        self.signInWithAppleProvider.authorization(
            onSuccess: { [weak self] (data) in
                guard let `self` = self else { return }
                UIAlertController()
                    .with(title: "Sign in with Apple")
                    .with(message: "uid: \(data.uid)")
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
