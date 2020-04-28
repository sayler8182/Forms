//
//  DemoSocialKitAllTableViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

#if canImport(SocialKit)

import Forms
import SocialKit
import UIKit

// MARK: DemoSocialKitAllTableViewController
class DemoSocialKitAllTableViewController: TableViewController {
    private let signInWithApple = Components.social.signInWithApple()
        .with(paddingEdgeInset: UIEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
    #if canImport(FBSDKLoginKit)
    private let signInWithFacebook = Components.social.signInWithFacebook()
        .with(paddingHorizontal: 16)
    #endif
    #if canImport(GoogleSignIn)
    private let signInWithGoogle = Components.social.signInWithGoogle()
        .with(paddingHorizontal: 16)
    #endif
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.signInWithApple
        ], divider: self.divider)
        
        DispatchQueue.main.async {
            #if canImport(FBSDKLoginKit)
            self.add([
                self.signInWithFacebook,
                self.divider
            ])
            #endif
            
            #if canImport(GoogleSignIn)
            self.add([
                self.signInWithGoogle,
                self.divider
            ])
            #endif
        }
    }
    
    override func setupConfiguration() {
        super.setupConfiguration()
        self.tableContentInset = UIEdgeInsets(vertical: 16)
    }
}

#endif
