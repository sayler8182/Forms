//
//  ComponentsOthers.swift
//  Forms
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public struct ComponentsOthers: ComponentsList {
    private init() { }
        
    public static func activityIndicator() -> ActivityIndicator {
        let component = ActivityIndicator()
        component.marginEdgeInset = UIEdgeInsets(0)
        component.height = UITableView.automaticDimension
        component.isAnimating = true
        component.paddingEdgeInset = UIEdgeInsets(0)
        component.onSetTheme = Strong(component) { component in
            component.backgroundColor = UIColor.clear
            component.color = Theme.Colors.gray
        }
        return component
    }
}
