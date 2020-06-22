//
//  ComponentsImageViews.swift
//  Forms
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public enum ComponentsImageViews: ComponentsList {
    public static func `default`() -> ImageView {
        let component = ImageView()
        component.contentMode = .center
        return component
    }
}
