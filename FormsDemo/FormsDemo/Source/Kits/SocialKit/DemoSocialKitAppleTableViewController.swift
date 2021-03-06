//
//  DemoSocialKitAppleTableViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsSocialKit
import FormsToastKit
import FormsUtils
import UIKit

// MARK: DemoSocialKitAppleTableViewController
class DemoSocialKitAppleTableViewController: FormsTableViewController {
    private let signInWithApple = Components.social.signInWithApple()
        .with(margin: 16)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    @available(iOS 13.0, *)
    private lazy var signInWithAppleProvider = DemoSignInWithAppleProvider(context: self)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.signInWithApple
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.signInWithApple.onClick = Unowned(self) { (_self) in
            if #available(iOS 13.0, *) {
                _self.signInWithAppleAuthorization()
            } 
        }
    }
}

// MARK: SignInWithApple
@available(iOS 13.0, *)
extension DemoSocialKitAppleTableViewController {
    func signInWithAppleAuthorization() {
        self.signInWithApple.startLoading()
        self.signInWithAppleProvider.authorization(
            onSuccess: { [weak self] (data) in
                guard let `self` = self else { return }
                UIAlertController(preferredStyle: .alert)
                    .with(title: "Sign in with Apple")
                    .with(message: "uid: \(data.uid)")
                    .with(action: "Ok")
                    .present(on: self)
            },
            onError: { [weak self] (error) in
                guard let `self` = self else { return }
                Toast.error()
                    .with(title: error.localizedDescription)
                    .show(in: self.navigationController)
            },
            onCompletion: { [weak self] (_, _) in
                guard let `self` = self else { return }
                self.signInWithApple.stopLoading()
        })
    }
}
