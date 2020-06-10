//
//  ComponentsButtons.swift
//  Forms
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsButtons: ComponentsList {
    public static func `default`() -> Button {
        let component = Button()
        component.animationTime = 0.1
        component.height = UITableView.automaticDimension
        component.isEnabled = true
        component.isLoading = false
        component.marginEdgeInset = UIEdgeInsets(0)
        component.minHeight = 44.0
        component.maxHeight = CGFloat.greatestConstraintConstant
        component.title = nil
        component.titleEdgeInset = UIEdgeInsets(
            vertical: 5,
            horizontal: 16)
        component.titleNumberOfLines = 2
        component.titleTextAlignment = NSTextAlignment.center
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColors = Button.State<UIColor?>(
                active: Theme.Colors.blue,
                selected: Theme.Colors.blue.withAlphaComponent(0.7),
                disabled: Theme.Colors.gray,
                loading: Theme.Colors.blue)
            component.titleColors = Button.State<UIColor?>(UIColor.white)
            component.titleFonts = Button.State<UIFont>(Theme.Fonts.regular(ofSize: 14))
        }
        return component
    }
}
