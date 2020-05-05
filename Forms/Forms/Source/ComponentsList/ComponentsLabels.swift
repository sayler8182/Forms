//
//  ComponentsLabels.swift
//  Forms
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public struct ComponentsLabels: ComponentsList {
    private init() { }
    
    public static func `default`() -> Label {
        let component = Label()
        component.alignment = .natural
        component.animationTime = 0.2
        component.attributedText = nil
        component.backgroundColor = Theme.systemBackground
        component.color = Theme.label
        component.marginEdgeInset = UIEdgeInsets(0)
        component.font = UIFont.systemFont(ofSize: 14)
        component.height = UITableView.automaticDimension
        component.isUserInteractionEnabled = true
        component.minHeight = 0.0
        component.maxHeight = CGFloat.greatestConstraintConstant
        component.numberOfLines = 1
        component.paddingEdgeInset = UIEdgeInsets(0)
        component.text = nil
        return component
    }
}
