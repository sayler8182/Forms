//
//  Components.swift
//  Forms
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

public struct Components {
    private init() { }
    
    public typealias button = ComponentsButtons
    public typealias input = ComponentsInputs
    public typealias label = ComponentsLabels
    public typealias navigationBar = ComponentsNavigationBars
    public typealias other = ComponentsOther
    public typealias utils = ComponentsUtils
}

public protocol ComponentsList { }
public extension ComponentsList {
    static var theme: ThemeProtocol {
        return Forms.injector.resolve(ThemeProtocol.self)
    }
}
