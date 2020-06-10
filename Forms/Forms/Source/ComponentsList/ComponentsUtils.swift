//
//  ComponentsUtils.swift
//  Forms
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsUtils: ComponentsList {
    public static func divider() -> Divider {
        let component = Divider()
        component.height = 1
        component.onSetTheme = Strong(component) { (component) in
            component.color = Theme.Colors.primaryBackground
        }
        return component
    } 
}
