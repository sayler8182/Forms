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
        component.batchUpdate {
            component.marginEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16)
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColors = .init(Theme.Colors.clear)
                component.selectedTintColors = SegmentControl.State<UIColor?>(Theme.Colors.primaryLight)
                    .with(selected: Theme.Colors.primaryDark)
                    .with(disabled: Theme.Colors.tertiaryLight)
                    .with(disabledSelected: Theme.Colors.tertiaryDark)
                component.textColors = SegmentControl.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(selected: Theme.Colors.primaryLight)
                    .with(disabled: Theme.Colors.tertiaryDark)
                    .with(disabledSelected: Theme.Colors.tertiaryLight)
                component.textFonts = SegmentControl.State<UIFont>(Theme.Fonts.regular(ofSize: 12))
                    .with(selected: Theme.Fonts.bold(ofSize: 12))
                component.tintColors = SegmentControl.State<UIColor?>(Theme.Colors.primaryLight)
                    .with(selected: Theme.Colors.primaryDark)
                    .with(disabled: Theme.Colors.tertiaryLight)
                    .with(disabledSelected: Theme.Colors.tertiaryDark)
            }
        }
        return component
    }
}
