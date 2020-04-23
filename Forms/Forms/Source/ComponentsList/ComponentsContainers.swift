//
//  ComponentsContainers.swift
//  Forms
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public struct ComponentsContainers: ComponentsList {
    private init() { }
    
    public static func scroll() -> ScrollContainer {
        let component = ScrollContainer()
        component.automaticInterval = 5.0
        component.backgroundColor = UIColor.systemBackground
        component.bounces = true
        component.edgeInset = UIEdgeInsets(0)
        component.height = 100
        component.isAutomatic = false
        component.isPagingEnabled = true
        component.paddingEdgeInset = UIEdgeInsets(0)
        component.pageBackgroundColor = UIColor.clear
        component.pageIndicatorTintColor = UIColor.lightGray
        component.pageCurrentPageIndicatorTintColor = UIColor.gray
        component.pageIsHidden = false
        component.scrollDirection = .horizontal
        return component
    }
    
    public static func stack() -> StackContainer {
        let component = StackContainer()
        component.alignment = .fill
        component.axis = .horizontal
        component.backgroundColor = UIColor.systemBackground
        component.distribution = .fillEqually
        component.edgeInset = UIEdgeInsets(0)
        component.height = 100
        component.paddingEdgeInset = UIEdgeInsets(0)
        return component
    }
    
    public static func view() -> View {
        let component = View()
        component.height = UITableView.automaticDimension
        component.color = UIColor.systemBackground
        return component
    }
}
