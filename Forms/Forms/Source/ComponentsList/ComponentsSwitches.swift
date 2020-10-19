//
//  ComponentsSwitches.swift
//  Forms
//
//  Created by Konrad on 6/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsSwitches: ComponentsList {
    public static func `default`() -> Switch {
        let component = Switch()
        component.batchUpdate {
            component.marginEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16)
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColors = .init(Theme.Colors.clear)
                component.switchColors = .init(Theme.Colors.blue)
                component.switchThumbColors = Switch.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(disabled: Theme.Colors.tertiaryDark)
                    .with(disabledSelected: Theme.Colors.tertiaryDark)
                component.titleColors = Switch.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(disabled: Theme.Colors.tertiaryDark)
                    .with(disabledSelected: Theme.Colors.tertiaryDark)
                component.titleFonts = .init(Theme.Fonts.bold(ofSize: 12))
                component.valueColors = Switch.State<UIColor?>(Theme.Colors.secondaryDark)
                    .with(disabled: Theme.Colors.tertiaryDark)
                    .with(disabledSelected: Theme.Colors.tertiaryDark)
                component.valueFonts = .init(Theme.Fonts.regular(ofSize: 10))
            }
        }
        return component
    }
}
