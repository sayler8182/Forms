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
        component.cornerRadius = 6
        component.height = UITableView.automaticDimension
        component.marginEdgeInset = UIEdgeInsets(0)
        component.paddingEdgeInset = UIEdgeInsets(
            vertical: 5,
            horizontal: 16)
        component.title = "Sign in with Apple"
        component.titleTextAlignment = .center
        component.onSetTheme = Unowned(component) { (component) in
            component.backgroundColors = Button.State<UIColor?>(
                active: Theme.Colors.appleSocialKit,
                selected: Theme.Colors.appleSocialKit.withAlphaComponent(0.7),
                disabled: Theme.Colors.gray)
            component.titleColors = Button.State<UIColor?>(Theme.Colors.primaryLight)
            component.titleFonts = Button.State<UIFont>(Theme.Fonts.regular(ofSize: 12))
        }
        return component
    }
    
    public static func signInWithFacebook() -> Button {
        let component = Button()
        component.cornerRadius = 6
        component.height = UITableView.automaticDimension
        component.marginEdgeInset = UIEdgeInsets(0)
        component.paddingEdgeInset = UIEdgeInsets(
            vertical: 6,
            horizontal: 16)
        component.title = "Sign in with Facebook"
        component.titleTextAlignment = .center
        component.onSetTheme = Unowned(component) { (component) in
            component.backgroundColors = Button.State<UIColor?>(
                active: Theme.Colors.facebookSocialKit,
                selected: Theme.Colors.facebookSocialKit.withAlphaComponent(0.7),
                disabled: Theme.Colors.gray)
            component.titleColors = Button.State<UIColor?>(Theme.Colors.white)
            component.titleFonts = Button.State<UIFont>(Theme.Fonts.regular(ofSize: 12))
        }
        return component
    }
    
    public static func signInWithGoogle() -> Button {
        let component = Button()
        component.cornerRadius = 6
        component.height = UITableView.automaticDimension
        component.marginEdgeInset = UIEdgeInsets(0)
        component.paddingEdgeInset = UIEdgeInsets(
            vertical: 6,
            horizontal: 16)
        component.title = "Sign in with Google"
        component.titleTextAlignment = .center
        component.onSetTheme = Unowned(component) { (component) in
            component.backgroundColors = Button.State<UIColor?>(
                active: Theme.Colors.googleSocialKit,
                selected: Theme.Colors.googleSocialKit.withAlphaComponent(0.7),
                disabled: Theme.Colors.gray)
            component.titleColors = Button.State<UIColor?>(Theme.Colors.white)
            component.titleFonts = Button.State<UIFont>(Theme.Fonts.regular(ofSize: 12))
        }
        return component
    }
}
