//
//  ComponentsSocial.swift
//  FormsSocialKit
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsUtils
import UIKit

public enum ComponentsSocial: ComponentsList {
    public static func signInWithApple() -> Button {
        let component = Button()
        component.batchUpdate {
            component.cornerRadius = 6
            component.paddingEdgeInset = UIEdgeInsets(
                vertical: 5,
                horizontal: 16)
            component.title = "Sign in with Apple"
            component.titleTextAlignment = .center
            component.onSetTheme = Unowned(component) { (component) in
                component.backgroundColors = .init(default: Theme.Colors.appleSocialKit)
                component.titleColors = .init(Theme.Colors.primaryLight)
                component.titleFonts = .init(Theme.Fonts.regular(ofSize: 12))
            }
        }
        return component
    }
    
    public static func signInWithEmail() -> Button {
        let component = GradientButton()
        component.batchUpdate {
            component.cornerRadius = 6
            component.paddingEdgeInset = UIEdgeInsets(
                vertical: 5,
                horizontal: 16)
            component.title = "Sign in with Email"
            component.titleTextAlignment = .center
            component.onSetTheme = Unowned(component) { (component) in
                component.backgroundColors = .init(default: Theme.Colors.blue)
                component.titleColors = .init(Theme.Colors.white)
                component.titleFonts = .init(Theme.Fonts.regular(ofSize: 12))
            }
        }
        return component
    }
    
    public static func signInWithFacebook() -> Button {
        let component = Button()
        component.batchUpdate {
            component.cornerRadius = 6
            component.paddingEdgeInset = UIEdgeInsets(
                vertical: 6,
                horizontal: 16)
            component.title = "Sign in with Facebook"
            component.titleTextAlignment = .center
            component.onSetTheme = Unowned(component) { (component) in
                component.backgroundColors = .init(default: Theme.Colors.facebookSocialKit)
                component.titleColors = .init(Theme.Colors.white)
                component.titleFonts = .init(Theme.Fonts.regular(ofSize: 12))
            }
        }
        return component
    }
    
    public static func signInWithGoogle() -> Button {
        let component = Button()
        component.batchUpdate {
            component.cornerRadius = 6
            component.paddingEdgeInset = UIEdgeInsets(
                vertical: 6,
                horizontal: 16)
            component.title = "Sign in with Google"
            component.titleTextAlignment = .center
            component.onSetTheme = Unowned(component) { (component) in
                component.backgroundColors = .init(default: Theme.Colors.googleSocialKit)
                component.titleColors = .init(Theme.Colors.white)
                component.titleFonts = .init(Theme.Fonts.regular(ofSize: 12))
            }
        }
        return component
    }
}
