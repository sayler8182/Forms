//
//  ComponentsMap.swift
//  FormsMapKit
//
//  Created by Konrad on 10/26/20.
//

import Forms
import FormsUtils
import UIKit

public enum ComponentsMap: ComponentsList {
    public static func apple() -> MapApple {
        let component = MapApple()
        component.batchUpdate {
            component.onSetTheme = Unowned(component) { (component) in
                component.backgroundColor = Theme.Colors.primaryLight
            }
        }
        return component
    }
}
