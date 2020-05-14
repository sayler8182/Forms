//
//  ComponentsSections.swift
//  Forms
//
//  Created by Konrad on 5/13/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public struct ComponentsSections: ComponentsList {
    private init() { }
    
    public static func `default`() -> SectionView {
        let component = SectionView()
        component.translatesAutoresizingMaskIntoConstraints = true
        component.alignment = .natural
        component.animationTime = 0.2
        component.attributedText = nil
        component.backgroundColor = Theme.Colors.secondaryBackground
        component.color = Theme.Colors.primaryText
        component.marginEdgeInset = UIEdgeInsets(0)
        component.font = Theme.Fonts.bold(ofSize: 14)
        component.height = UITableView.automaticDimension
        component.isUserInteractionEnabled = true
        component.minHeight = 0.0
        component.maxHeight = CGFloat.greatestConstraintConstant
        component.numberOfLines = 1
        component.paddingEdgeInset = UIEdgeInsets(top: 15, left: 15, bottom: 4, right: 15)
        component.text = nil
        component.onSetTheme = { [weak component] in
            guard let component = component else { return }
            component.backgroundColor = Theme.Colors.secondaryBackground
            component.color = Theme.Colors.primaryText
            component.font = Theme.Fonts.bold(ofSize: 14)
        }
        return component
    }
}
