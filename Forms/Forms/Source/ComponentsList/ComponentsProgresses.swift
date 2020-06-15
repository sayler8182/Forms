//
//  ComponentsProgresses.swift
//  Forms
//
//  Created by Konrad on 5/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsProgresses: ComponentsList {
    public static func progressBar() -> ProgressBar {
        let component = ProgressBar()
        component.animationTime = 0.2
        component.isShimmerable = false
        component.marginEdgeInset = UIEdgeInsets(0)
        component.height = 4
        component.paddingEdgeInset = UIEdgeInsets(0)
        component.progress = 0
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColor = Theme.Colors.primaryLight
            component.primaryColor = Theme.Colors.blue.withAlphaComponent(0.5)
            component.secondaryColor = Theme.Colors.blue
        }
        return component
    }
}
