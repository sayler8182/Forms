//
//  ComponentsUtils.swift
//  Forms
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsUtils: ComponentsList {
    public static func divider(height: CGFloat = 1) -> Divider {
        let component = Divider()
        component.batchUpdate {
            component.isShimmerable = false
            component.height = 1
            component.onSetTheme = Strong(component) { (component) in
                component.color = Theme.Colors.clear
            }
        }
        return component
    }
    
    public static func gradientDivider(height: CGFloat = 1) -> GradientDivider {
        let component = GradientDivider()
        component.batchUpdate {
            component.isShimmerable = false
            component.height = 1
            component.onSetTheme = Strong(component) { (component) in
                component.colors = [Theme.Colors.clear]
            }
        }
        return component
    }
    
    public static func confetti() -> Confetti {
        let component = Confetti()
        component.batchUpdate {
            component.items = [
                .shape(.circle, Theme.Colors.primaryDark),
                .shape(.rectangle(4, 16), Theme.Colors.primaryDark),
                .shape(.bezierPath(UIBezierPath(size: CGSize(size: 16))), Theme.Colors.primaryDark)
            ]
            component.onSetTheme = Strong(component) { (component) in
                component.color = Theme.Colors.primaryLight
            }
        }
        return component
    }
}
