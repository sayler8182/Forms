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
    public static func clickable() -> ClickableView {
        let component = ClickableView()
        component.height = 100
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColor = Theme.Colors.primaryLight
        }
        return component
    }
    
    public static func gradient() -> GradientView {
        let component = GradientView()
        component.onSetTheme = Strong(component) { (component) in
            component.gradientColors = [Theme.Colors.primaryLight]
        }
        return component
    }
    
    public static func scroll() -> ScrollContainer {
        let component = ScrollContainer()
        component.height = 100
        component.scrollDelegate = component
        component.scrollDirection = .horizontal
        component.showsHorizontalScrollIndicator = false
        component.showsVerticalScrollIndicator = false
        component.spacing = 0
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColor = Theme.Colors.primaryLight
        }
        return component
    }
    
    public static func page() -> PageContainer {
        let component = PageContainer()
        component.height = 100
        component.isPagingEnabled = true
        component.scrollDirection = .horizontal
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColor = Theme.Colors.primaryLight
            component.pageBackgroundColor = Theme.Colors.clear
            component.pageCurrentPageIndicatorTintColor = Theme.Colors.primaryDark
            component.pageIndicatorTintColor = Theme.Colors.gray
        }
        return component
    }
    
    public static func stack() -> StackContainer {
        let component = StackContainer()
        component.alignment = .fill
        component.axis = .vertical
        component.distribution = .fillEqually
        component.height = 100
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColor = Theme.Colors.primaryLight
        }
        return component
    }
    
    public static func view() -> View {
        let component = View()
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColor = Theme.Colors.primaryLight
        }
        return component
    }
}
