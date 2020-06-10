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
        component.animationTime = 0.1
        component.images = Checkbox.State<(() -> UIImage?)?>(
            active: { UIImage.from(name: "stop") },
            selected: { UIImage.from(name: "checkmark.square.fill") })
        component.imageSize = CGSize(size: 22)
        component.isEnabled = true
        component.isSelected = false
        component.marginEdgeInset = UIEdgeInsets(0)
        component.paddingEdgeInset = UIEdgeInsets(
            vertical: 8,
            horizontal: 16)
        component.title = nil
        component.value = nil
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColors = Checkbox.State<UIColor?>(Theme.Colors.primaryBackground)
            component.imageColors = Checkbox.State<UIColor?>(
                active: Theme.Colors.primaryText,
                selected: Theme.Colors.primaryText,
                disabled: Theme.Colors.tertiaryText)
            component.titleColors = Checkbox.State<UIColor?>(
                active: Theme.Colors.primaryText,
                selected: Theme.Colors.primaryText,
                disabled: Theme.Colors.tertiaryText)
            component.titleFonts = Checkbox.State<UIFont>(Theme.Fonts.bold(ofSize: 12))
            component.valueColors = Checkbox.State<UIColor?>(
                active: Theme.Colors.secondaryText,
                selected: Theme.Colors.secondaryText,
                disabled: Theme.Colors.tertiaryText)
            component.valueFonts = Checkbox.State<UIFont>(Theme.Fonts.regular(ofSize: 10))
        }
        return component
    }
    
    public static func radio() -> Checkbox {
        let component = Checkbox()
        component.animationTime = 0.1
        component.groupKey = "_radio_group"
        component.images = Checkbox.State<(() -> UIImage?)?>(
            active: { UIImage.from(name: "circle") },
            selected: { UIImage.from(name: "stop.circle") })
        component.imageSize = CGSize(size: 22)
        component.isEnabled = true
        component.isSelected = false
        component.marginEdgeInset = UIEdgeInsets(0)
        component.paddingEdgeInset = UIEdgeInsets(
            vertical: 8,
            horizontal: 16)
        component.title = nil
        component.value = nil
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColors = Checkbox.State<UIColor?>(Theme.Colors.primaryBackground)
            component.imageColors = Checkbox.State<UIColor?>(
                active: Theme.Colors.primaryText,
                selected: Theme.Colors.primaryText,
                disabled: Theme.Colors.tertiaryText)
            component.titleColors = Checkbox.State<UIColor?>(
                active: Theme.Colors.primaryText,
                selected: Theme.Colors.primaryText,
                disabled: Theme.Colors.tertiaryText)
            component.titleFonts = Checkbox.State<UIFont>(Theme.Fonts.bold(ofSize: 12))
            component.valueColors = Checkbox.State<UIColor?>(
                active: Theme.Colors.secondaryText,
                selected: Theme.Colors.secondaryText,
                disabled: Theme.Colors.tertiaryText)
            component.valueFonts = Checkbox.State<UIFont>(Theme.Fonts.regular(ofSize: 10))
        }
        return component
    }
}
