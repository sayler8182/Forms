//
//  DemoSocialKitAllTableViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import SocialKit
import UIKit

// MARK: DemoSocialKitAllTableViewController
class DemoSocialKitAllTableViewController: FormsTableViewController {
    private let signInWithApple = Components.social.signInWithApple()
        .with(paddingEdgeInset: UIEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
    private let signInWithFacebook = Components.social.signInWithFacebook()
        .with(paddingHorizontal: 16)
    private let signInWithGoogle = Components.social.signInWithGoogle()
        .with(paddingHorizontal: 16)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.signInWithApple,
            self.signInWithFacebook,
            self.signInWithGoogle
        ], divider: self.divider)
    }
}
