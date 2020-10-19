//
//  ComponentsPickers.swift
//  Forms
//
//  Created by Konrad on 10/20/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

public enum ComponentsPickers: ComponentsList {
    public static func single() -> SinglePicker {
        let component = SinglePicker()
        return component
    }
}
