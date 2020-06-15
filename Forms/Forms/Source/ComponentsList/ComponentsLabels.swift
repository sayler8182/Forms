//
//  ComponentsLabels.swift
//  Forms
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsLabels: ComponentsList {
    public static func `default`() -> Label {
        let component = Label()
        component.alignment = .natural
        component.animationTime = 0.2
        component.attributedText = nil
        component.marginEdgeInset = UIEdgeInsets(0)
        component.height = UITableView.automaticDimension
        component.isUserInteractionEnabled = true
        component.minHeight = 0.0
        component.maxHeight = CGFloat.greatestConstraintConstant
        component.numberOfLines = 1
        component.paddingEdgeInset = UIEdgeInsets(0)
        component.text = nil
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColor = Theme.Colors.clear
            component.color = Theme.Colors.primaryDark
            component.font = Theme.Fonts.regular(ofSize: 14)}
        return component
    }
}
