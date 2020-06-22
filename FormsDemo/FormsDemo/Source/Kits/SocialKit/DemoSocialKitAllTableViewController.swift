//
//  DemoSocialKitAllTableViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsSocialKit
import UIKit

// MARK: DemoSocialKitAllTableViewController
class DemoSocialKitAllTableViewController: FormsTableViewController {
    private let signInWithApple: FormsComponent? = {
        if #available(iOS 13.0, *) {
            return Components.social.signInWithApple()
                .with(marginEdgeInset: UIEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        } else {
            return nil
        }
    }()
    private let signInWithFacebook = Components.social.signInWithFacebook()
        .with(marginHorizontal: 16)
    private let signInWithGoogle = Components.social.signInWithGoogle()
        .with(marginHorizontal: 16)
    private let signInWithEmail = Components.social.signInWithEmail()
        .with(marginHorizontal: 16)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.signInWithApple,
            self.signInWithFacebook,
            self.signInWithGoogle,
            self.signInWithEmail
        ], divider: self.divider)
    }
}
