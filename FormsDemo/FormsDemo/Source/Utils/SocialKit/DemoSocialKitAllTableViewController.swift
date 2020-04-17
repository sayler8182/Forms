//
//  DemoSocialKitAllTableViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DemoSocialKitAllTableViewController
class DemoSocialKitAllTableViewController: TableViewController {
    private let signInWithApple = Components.social.signInWithApple()
        .with(paddingEdgeInset: UIEdgeInsets(horizontal: 16))
    private let signInWithFacebook = Components.social.signInWithFacebook()
        .with(paddingEdgeInset: UIEdgeInsets(horizontal: 16))
    private let signInWithGoogle = Components.social.signInWithGoogle()
        .with(paddingEdgeInset: UIEdgeInsets(horizontal: 16))
    
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
    
    override func setupConfiguration() {
        super.setupConfiguration()
        self.tableContentInset = UIEdgeInsets(vertical: 16)
    }
}
