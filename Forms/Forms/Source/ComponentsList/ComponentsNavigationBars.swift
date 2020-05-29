//
//  ComponentsNavigationBars.swift
//  Forms
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public struct ComponentsNavigationBars: ComponentsList {
    private init() { }
        
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
        component.onSetTheme = { [weak component] in
            guard let component = component else { return }
            component.backgroundColor = Theme.Colors.primaryBackground
            component.tintColor = Theme.Colors.primaryText
        }
        return component
    }
}
