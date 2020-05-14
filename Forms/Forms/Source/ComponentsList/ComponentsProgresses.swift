//
//  ComponentsProgresses.swift
//  Forms
//
//  Created by Konrad on 5/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public struct ComponentsProgresses: ComponentsList {
    private init() { }
        
    public static func progressBar() -> ProgressBar {
        let component = ProgressBar()
        component.animationTime = 0.2
        component.backgroundColor = Theme.Colors.primaryBackground
        component.marginEdgeInset = UIEdgeInsets(0)
        component.height = 4
        component.paddingEdgeInset = UIEdgeInsets(0)
        component.primaryColor = Theme.Colors.primaryText.withAlphaComponent(0.5)
        component.progress = 0
        component.secondaryColor = Theme.Colors.primaryText
        component.onSetTheme = { [weak component] in
            guard let component = component else { return }
            component.backgroundColor = Theme.Colors.primaryBackground
            component.primaryColor = Theme.Colors.primaryText.withAlphaComponent(0.5)
            component.secondaryColor = Theme.Colors.primaryText
        }
        return component
    }
}
