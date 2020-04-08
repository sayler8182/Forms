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
    
    public static func label() -> Label {
        let component = Label()
        
        component.alignment = .natural
        component.animationTime = 0.2
        component.attributedText = nil
        component.backgroundColor = UIColor.white
        component.color = self.theme.textPrimaryColor
        component.edgeInset = UIEdgeInsets(0)
        component.font = UIFont.systemFont(ofSize: 16)
        component.height = UITableView.automaticDimension
        component.isUserInteractionEnabled = true
        component.minHeight = 0.0
        component.maxHeight = CGFloat.greatestConstraintConstant
        component.numberOfLines = 0
        component.paddingEdgeInset = UIEdgeInsets(0)
        component.text = nil
        return component
    }
}
