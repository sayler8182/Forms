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
        component.batchUpdate {
            component.isShimmerable = false
            component.height = 4
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColor = Theme.Colors.primaryLight
                component.primaryColor = Theme.Colors.blue.with(alpha: 0.5)
                component.secondaryColor = Theme.Colors.blue
            }
        }
        return component
    }
}
