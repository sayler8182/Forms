//
//  ComponentsSliders.swift
//  Forms
//
//  Created by Konrad on 10/22/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsSliders: ComponentsList {
    public static func `default`() -> Slider {
        let component = Slider()
        component.batchUpdate {
            component.marginEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16)
            component.onSetTheme = Strong(component) { (component) in
                component.minimumTrackTintColor = Theme.Colors.primaryDark
                component.maximumTrackTintColor = Theme.Colors.secondaryDark
                component.thumbTintColor = Theme.Colors.primaryDark
            }
        }
        return component
    }
}
