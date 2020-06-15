//
//  ComponentsNavigationBars.swift
//  Forms
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsNavigationBars: ComponentsList {
    public static func `default`() -> NavigationBar {
        let component = NavigationBar()
        component.backImage = { UIImage.from(name: "chevron.left") }
        component.closeImage = { UIImage.from(name: "xmark") }
        component.isBack = true
        component.isShadow = true
        component.isTranslucent = false
        component.leftBarButtonItems = []
        component.rightBarButtonItems = []
        component.title = nil
        component.titleView = nil
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColor = Theme.Colors.primaryLight
            component.tintColor = Theme.Colors.primaryDark
        }
        return component
    }
}
