//
//  ComponentsSections.swift
//  Forms
//
//  Created by Konrad on 5/13/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsSections: ComponentsList {    
    public static func `default`() -> SectionView {
        let component = SectionView()
        component.translatesAutoresizingMaskIntoConstraints = true
        component.minHeight = 0.0
        component.maxHeight = CGFloat.greatestConstraintConstant
        component.paddingEdgeInset = UIEdgeInsets(top: 15, left: 15, bottom: 4, right: 15)
        component.onSetTheme = Strong(component) { (component) in
            component.backgroundColor = Theme.Colors.secondaryLight
            component.color = Theme.Colors.primaryDark
            component.font = Theme.Fonts.bold(ofSize: 14)
        }
        return component
    }
}
