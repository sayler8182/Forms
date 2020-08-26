//
//  ComponentsOthers.swift
//  Forms
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsOthers: ComponentsList {
    public static func activityIndicator() -> ActivityIndicator {
        let component = ActivityIndicator()
        component.batchUpdate {
            component.isAnimating = true
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColor = Theme.Colors.clear
                component.color = Theme.Colors.gray
            }
        }
        return component
    }
}
