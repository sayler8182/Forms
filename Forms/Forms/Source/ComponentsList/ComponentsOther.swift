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
        component.color = UIColor.lightGray
        component.edgeInset = UIEdgeInsets(0)
        component.height = UITableView.automaticDimension
        component.isAnimating = true
        component.paddingEdgeInset = UIEdgeInsets(0)
        component.style = .medium
        return component
    }
}
