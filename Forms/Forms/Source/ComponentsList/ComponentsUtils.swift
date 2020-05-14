//
//  ComponentsUtils.swift
//  Forms
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public struct ComponentsUtils: ComponentsList {
    private init() { }
    
    public static func divider() -> Divider {
        let component = Divider()
        component.height = 1
        component.onSetTheme = { [weak component] in
            guard let component = component else { return }
            component.color = Theme.Colors.primaryBackground
        }
        return component
    } 
}
