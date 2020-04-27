//
//  DeveloperToolsMenu.swift
//  DeveloperTools
//
//  Created by Konrad on 4/26/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DeveloperToolsMenu
public protocol DeveloperToolsMenu: class {
    typealias OnSelect = (_ key: DeveloperFeatureKey, _ rootController: UIViewController) -> Void
    
    init(features: DeveloperFeatures,
         onSelect: OnSelect?) 
}
