//
//  ComponentsOther.swift
//  Forms
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public struct ComponentsOther: ComponentsList {
    private init() { }
        
    public static func activityIndicator() -> ActivityIndicator {
        let component = ActivityIndicator()
        component.backgroundColor = UIColor.clear
        component.color = Theme.Colors.gray
        component.marginEdgeInset = UIEdgeInsets(0)
        component.height = UITableView.automaticDimension
        component.isAnimating = true
        component.paddingEdgeInset = UIEdgeInsets(0)
        component.onSetTheme = { [weak component] in
            guard let component = component else { return }
            component.backgroundColor = UIColor.clear
            component.color = Theme.Colors.gray
        }
        return component
    }
}
