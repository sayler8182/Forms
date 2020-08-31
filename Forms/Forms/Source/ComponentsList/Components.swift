//
//  Components.swift
//  Forms
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

public enum Components {
    public typealias button = ComponentsButtons
    public typealias checkbox = ComponentsCheckboxes
    public typealias container = ComponentsContainers
    public typealias dates = ComponentsDates
    public typealias image = ComponentsImageViews
    public typealias input = ComponentsInputs
    public typealias label = ComponentsLabels
    public typealias navigationBar = ComponentsNavigationBars
    public typealias other = ComponentsOthers
    public typealias progress = ComponentsProgresses
    public typealias section = ComponentsSections
    public typealias segment = ComponentsSegments
    public typealias selector = ComponentsSelectors
    public typealias `switch` = ComponentsSwitches
    public typealias utils = ComponentsUtils
}

public protocol ComponentsList { }
