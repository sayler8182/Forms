//
//  ComponentsNavigationBars.swift
//  Forms
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public struct ComponentsNavigationBars: ComponentsList {
    private init() { }
        
    public static func `default`() -> NavigationBar {
        let component = NavigationBar()
        component.backgroundColor = nil
        if #available(iOS 13.0, *) {
            component.backImage = { UIImage(systemName: "chevron.left") }
            component.closeImage = { UIImage(systemName: "xmark") }
        }
        component.isBack = true
        component.isShadow = true
        component.isTranslucent = false
        component.leftBarButtonItems = []
        component.rightBarButtonItems = []
        component.tintColor = nil
        component.title = nil
        component.titleView = nil
        return component
    }
}
