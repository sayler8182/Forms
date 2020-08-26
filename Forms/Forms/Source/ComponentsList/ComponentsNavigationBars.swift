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
        component.batchUpdate {
            component.backImage = { UIImage.from(name: "chevron.left") }
            component.closeImage = { UIImage.from(name: "xmark") }
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColor = Theme.Colors.primaryLight
                component.tintColor = Theme.Colors.primaryDark
            }
        }
        return component
    }
}
