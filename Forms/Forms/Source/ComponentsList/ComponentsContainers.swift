//
//  ComponentsContainers.swift
//  Forms
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsContainers: ComponentsList {
    public static func scroll() -> ScrollContainer {
        let component = ScrollContainer()
        component.bounces = true
        component.height = 100
        component.marginEdgeInset = UIEdgeInsets(0)
        component.paddingEdgeInset = UIEdgeInsets(0)
        component.scrollDelegate = component
        component.scrollDirection = .horizontal
        component.scrollSteps = nil
        component.showsHorizontalScrollIndicator = false
        component.showsVerticalScrollIndicator = false
        component.spacing = 0
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColor = Theme.Colors.primaryBackground
        }
        return component
    }
    
    public static func page() -> PageContainer {
        let component = PageContainer()
        component.automaticInterval = 5.0
        component.bounces = true
        component.height = 100
        component.marginEdgeInset = UIEdgeInsets(0)
        component.isAutomatic = false
        component.isPagingEnabled = true
        component.paddingEdgeInset = UIEdgeInsets(0)
        component.pageBackgroundColor = UIColor.clear
        component.pageIndicatorTintColor = Theme.Colors.gray
        component.pageCurrentPageIndicatorTintColor = UIColor.gray
        component.pageIsHidden = false
        component.scrollDirection = .horizontal
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColor = Theme.Colors.primaryBackground
        }
        return component
    }
    
    public static func stack() -> StackContainer {
        let component = StackContainer()
        component.alignment = .fill
        component.axis = .horizontal
        component.distribution = .fillEqually
        component.marginEdgeInset = UIEdgeInsets(0)
        component.height = 100
        component.paddingEdgeInset = UIEdgeInsets(0)
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColor = Theme.Colors.primaryBackground
        }
        return component
    }
    
    public static func view() -> View {
        let component = View()
        component.height = UITableView.automaticDimension
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColor = Theme.Colors.primaryBackground
        }
        return component
    }
}
