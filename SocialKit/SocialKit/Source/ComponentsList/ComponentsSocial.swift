//
//  ComponentsSocial.swift
//  SocialKit
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public struct ComponentsSocial: ComponentsList {
    private init() { }
        
    public static func signInWithApple() -> SignInWithApple {
        let component = SignInWithApple()
        component.edgeInset = UIEdgeInsets(0)
        component.height = UITableView.automaticDimension
        component.paddingEdgeInset = UIEdgeInsets(0)
        return component
    }
    
    public static func signInWithFacebook() -> SignInWithFacebook {
        let component = SignInWithFacebook()
        component.edgeInset = UIEdgeInsets(0)
        component.height = UITableView.automaticDimension
        component.title = "Sign in with Facebook"
        component.paddingEdgeInset = UIEdgeInsets(0)
        return component
    }
    
    public static func signInWithGoogle() -> SignInWithGoogle {
        let component = SignInWithGoogle()
        component.edgeInset = UIEdgeInsets(0)
        component.height = UITableView.automaticDimension
        component.title = "Sign in with Google"
        component.paddingEdgeInset = UIEdgeInsets(0)
        return component
    }
}
