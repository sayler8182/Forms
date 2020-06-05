//
//  ComponentsSwitches.swift
//  Forms
//
//  Created by Konrad on 6/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public struct ComponentsSwitches: ComponentsList {
    private init() { }
    
    public static func `default`() -> Switch {
        let component = Switch()
        component.animationTime = 0.1
        component.isEnabled = true
        component.isSelected = false
        component.marginEdgeInset = UIEdgeInsets(0)
        component.paddingEdgeInset = UIEdgeInsets(
            vertical: 8,
            horizontal: 16)
        component.title = nil
        component.value = nil
        component.onSetTheme = Strong(component) { component in
            component.backgroundColors = Switch.State<UIColor?>(Theme.Colors.primaryBackground)
            component.switchColors = Switch.State<UIColor?>(Theme.Colors.blue)
            component.switchThumbColors = Switch.State<UIColor?>(
                active: Theme.Colors.primaryText,
                selected: Theme.Colors.primaryText,
                disabled: Theme.Colors.tertiaryText)
            component.titleColors = Switch.State<UIColor?>(
                active: Theme.Colors.primaryText,
                selected: Theme.Colors.primaryText,
                disabled: Theme.Colors.tertiaryText)
            component.titleFonts = Switch.State<UIFont>(Theme.Fonts.bold(ofSize: 12))
            component.valueColors = Switch.State<UIColor?>(
                active: Theme.Colors.secondaryText,
                selected: Theme.Colors.secondaryText,
                disabled: Theme.Colors.tertiaryText)
            component.valueFonts = Switch.State<UIFont>(Theme.Fonts.regular(ofSize: 10))
        }
        return component
    }
}
