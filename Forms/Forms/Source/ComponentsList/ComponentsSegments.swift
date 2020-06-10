//
//  ComponentsSegments.swift
//  Forms
//
//  Created by Konrad on 6/10/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsSegments: ComponentsList {
    public static func `default`() -> SegmentControl {
        let component = SegmentControl()
        component.animationTime = 0.1
        component.isEnabled = true
        component.items = []
        component.marginEdgeInset = UIEdgeInsets(0)
        component.paddingEdgeInset = UIEdgeInsets(
            vertical: 8,
            horizontal: 16)
        component.selected = nil
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColors = SegmentControl.State<UIColor?>(Theme.Colors.primaryBackground)
            component.textColors = SegmentControl.State<UIColor>(
                active: Theme.Colors.primaryText,
                selected: Theme.Colors.primaryBackground,
                disabled: Theme.Colors.tertiaryText,
                disabledSelected: Theme.Colors.tertiaryBackground)
            component.textFonts = SegmentControl.State<UIFont>(
                active: Theme.Fonts.regular(ofSize: 12),
                selected: Theme.Fonts.bold(ofSize: 12))
            component.tintColors = SegmentControl.State<UIColor?>(
                active: Theme.Colors.primaryBackground,
                selected: Theme.Colors.primaryText,
                disabled: Theme.Colors.tertiaryBackground,
                disabledSelected: Theme.Colors.tertiaryText)
        }
        return component
    }
}
