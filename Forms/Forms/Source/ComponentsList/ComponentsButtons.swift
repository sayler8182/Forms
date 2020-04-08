//
//  ComponentsButtons.swift
//  Forms
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public struct ComponentsButtons: ComponentsList {
    private init() { }
    
    public static func primary() -> PrimaryButton {
        let component = PrimaryButton()
        component.animationTime = 0.1
        component.backgroundColors = Button.State<UIColor?>(
            active: self.theme.primaryColor,
            selected: self.theme.primaryLightColor,
            disabled: self.theme.dividerColor
        )
        component.edgeInset = UIEdgeInsets(0)
        component.height = UITableView.automaticDimension
        component.isEnabled = true
        component.minHeight = 44.0
        component.maxHeight = CGFloat.greatestConstraintConstant
        component.title = nil
        component.titleColors = Button.State<UIColor?>(self.theme.primaryTextColor)
        component.titleEdgeInset = UIEdgeInsets(
            vertical: 5,
            horizontal: 16
        )
        component.titleFonts = Button.State<UIFont>(UIFont.systemFont(ofSize: 14))
        component.titleNumberOfLines = 2
        component.titleTextAlignment = NSTextAlignment.center
        return component
    }
}
