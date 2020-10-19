//
//  ComponentsCheckboxes.swift
//  Forms
//
//  Created by Konrad on 6/3/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsCheckboxes: ComponentsList {
    public static func checkbox() -> Checkbox {
        let component = Checkbox()
        component.batchUpdate {
            component.images = Checkbox.State<LazyImage?>({ UIImage.from(name: "stop") })
                .with(selected: { UIImage.from(name: "checkmark.square.fill") })
                .with(disabledSelected: { UIImage.from(name: "checkmark.square.fill") })
            component.imageSize = CGSize(size: 22)
            component.marginEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16)
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColors = .init(Theme.Colors.clear)
                component.imageColors = Checkbox.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(disabled: Theme.Colors.tertiaryDark)
                    .with(disabledSelected: Theme.Colors.tertiaryDark)
                component.titleColors = Checkbox.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(disabled: Theme.Colors.tertiaryDark)
                    .with(disabledSelected: Theme.Colors.tertiaryDark)
                component.titleFonts = .init(Theme.Fonts.bold(ofSize: 12))
                component.valueColors = Checkbox.State<UIColor?>(Theme.Colors.secondaryDark)
                    .with(disabled: Theme.Colors.tertiaryDark)
                    .with(disabledSelected: Theme.Colors.tertiaryDark)
                component.valueFonts = .init(Theme.Fonts.regular(ofSize: 10))
            }
        }
        return component
    }
    
    public static func radio() -> Checkbox {
        let component = Checkbox()
        component.batchUpdate {
            component.groupKey = "_radio_group"
            component.images = Checkbox.State<LazyImage?>({ UIImage.from(name: "circle") })
                .with(selected: { UIImage.from(name: "stop.circle") })
                .with(disabledSelected: { UIImage.from(name: "stop.circle") })
            component.imageSize = CGSize(size: 22)
            component.marginEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16)
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColors = .init(Theme.Colors.clear)
                component.imageColors = Checkbox.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(disabled: Theme.Colors.tertiaryDark)
                    .with(disabledSelected: Theme.Colors.tertiaryDark)
                component.titleColors = Checkbox.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(disabled: Theme.Colors.tertiaryDark)
                    .with(disabledSelected: Theme.Colors.tertiaryDark)
                component.titleFonts = .init(Theme.Fonts.bold(ofSize: 12))
                component.valueColors = Checkbox.State<UIColor?>(Theme.Colors.secondaryDark)
                    .with(disabled: Theme.Colors.tertiaryDark)
                    .with(disabledSelected: Theme.Colors.tertiaryDark)
                component.valueFonts = .init(Theme.Fonts.regular(ofSize: 10))
            }
        }
        return component
    }
}
