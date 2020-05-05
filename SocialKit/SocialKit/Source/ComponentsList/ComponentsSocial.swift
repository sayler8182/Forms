//
//  ComponentsSocial.swift
//  SocialKit
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

public struct ComponentsSocial: ComponentsList {
    private init() { }
        
    @available(iOS 13.0, *)
    public static func signInWithApple() -> SignInWithApple {
        let component = SignInWithApple()
        component.marginEdgeInset = UIEdgeInsets(0)
        component.height = UITableView.automaticDimension
        component.paddingEdgeInset = UIEdgeInsets(0)
        return component
    }
    
    #if canImport(FBSDKLoginKit)
    public static func signInWithFacebook() -> SignInWithFacebook {
        let component = SignInWithFacebook()
        component.marginEdgeInset = UIEdgeInsets(0)
        component.height = UITableView.automaticDimension
        component.title = "Sign in with Facebook"
        component.paddingEdgeInset = UIEdgeInsets(0)
        return component
    }
    #endif
    
    #if canImport(GoogleSignIn)
    public static func signInWithGoogle() -> SignInWithGoogle {
        let component = SignInWithGoogle()
        component.marginEdgeInset = UIEdgeInsets(0)
        component.height = UITableView.automaticDimension
        component.title = "Sign in with Google"
        component.paddingEdgeInset = UIEdgeInsets(0)
        return component
    }
    #endif
}
