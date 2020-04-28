//
//  ComponentsImageViews.swift
//  Forms
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public struct ComponentsImageViews: ComponentsList {
    private init() { }
    
    public static func `default`() -> ImageView {
        let component = ImageView()
        component.contentMode = .center
        component.height = UITableView.automaticDimension
        component.image = nil
        component.marginEdgeInset = UIEdgeInsets(0)
        component.paddingEdgeInset = UIEdgeInsets(0)
        return component
    }
}
