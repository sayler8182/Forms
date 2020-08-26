//
//  ComponentsLabels.swift
//  Forms
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsLabels: ComponentsList {
    public static func `default`() -> Label {
        let component = Label()
        component.batchUpdate {
            component.minHeight = 0.0
            component.maxHeight = CGFloat.greatestConstraintConstant
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColor = Theme.Colors.clear
                component.color = Theme.Colors.primaryDark
                component.font = Theme.Fonts.regular(ofSize: 14)
            }
        }
        return component
    }
}
