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
    public static func action() -> ActionProgressView {
        let component = ActionProgressView()
        component.batchUpdate {
            component.isShimmerable = false
            component.separatorView = {
                return UIImageView()
                    .with(contentMode: .center)
                    .with(image: ActionProgressItem.separator)
            }
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColors = .init(Theme.Colors.primaryLight)
                component.tintColors = ActionProgressView.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(selected: Theme.Colors.tertiaryDark)
            }
        }
        return component
    }
    
    public static func `default`() -> ProgressBar {
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
