//
//  ComponentsButtons.swift
//  Forms
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsButtons: ComponentsList {
    public static func `default`() -> Button {
        let component = Button()
        component.batchUpdate {
            component.minHeight = 44.0 
            component.maxHeight = CGFloat.greatestConstraintConstant
            component.paddingEdgeInset = UIEdgeInsets(
                vertical: 6,
                horizontal: 16)
            component.titleNumberOfLines = 2
            component.titleTextAlignment = .center
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColors = .init(default: Theme.Colors.blue)
                component.borderColors = .init(Theme.Colors.clear)
                component.titleColors = .init(Theme.Colors.white)
                component.titleFonts = .init(Theme.Fonts.regular(ofSize: 14))
            }
        }
        return component
    }
    
    public static func gradient() -> GradientButton {
        let component = GradientButton()
        component.batchUpdate {
            component.marginEdgeInset = UIEdgeInsets(0)
            component.minHeight = 44.0
            component.maxHeight = CGFloat.greatestConstraintConstant
            component.paddingEdgeInset = UIEdgeInsets(
                vertical: 6,
                horizontal: 16)
            component.titleNumberOfLines = 2
            component.titleTextAlignment = .center
            component.onSetTheme = Strong(component) { (component) in
                component.borderColors = .init(Theme.Colors.clear)
                component.gradientColors = .init(default: [Theme.Colors.blue, Theme.Colors.blue.with(alpha: 0.7)])
                component.titleColors = .init(Theme.Colors.white)
                component.titleFonts = .init(Theme.Fonts.regular(ofSize: 14))
            }
        }
        return component
    }
}
