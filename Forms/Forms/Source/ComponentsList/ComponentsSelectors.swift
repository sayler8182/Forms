//
//  ComponentsSelectors.swift
//  Forms
//
//  Created by Konrad on 8/21/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsSelectors: ComponentsList {
    public static func `default`() -> SelectorControl {
        let component = SelectorControl()
        component.batchUpdate {
            component.marginEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16)
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColors = .init(Theme.Colors.primaryLight)
                component.textColors = SelectorControl.State<UIColor>(Theme.Colors.primaryDark)
                    .with(disabled: Theme.Colors.tertiaryDark)
                component.textFonts = SelectorControl.State<UIFont>(Theme.Fonts.regular(ofSize: 12))
                    .with(selected: Theme.Fonts.bold(ofSize: 12))
                component.tintColors = SelectorControl.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(selected: Theme.Colors.secondaryDark)
                    .with(disabled: Theme.Colors.tertiaryDark)
            }
        }
        return component
    } 
}
