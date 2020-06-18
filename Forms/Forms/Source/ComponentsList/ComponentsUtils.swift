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
            component.color = Theme.Colors.primaryLight
        }
        return component
    }
    
    public static func confetti() -> Confetti {
        let component = Confetti()
        component.intensity = 1.0
        component.items = [
            .shape(.circle, Theme.Colors.primaryDark),
            .shape(.rectangle(4, 16), Theme.Colors.primaryDark),
            .shape(.bezierPath(UIBezierPath(size: CGSize(size: 16))), Theme.Colors.primaryDark)
            ]
            .compactMap { $0 }
        component.onSetTheme = Strong(component) { (component) in
            component.color = Theme.Colors.primaryLight
        }
        return component
    }
}
