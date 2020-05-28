//
//  Bool.swift
//  FormsUtils
//
//  Created by Konrad on 4/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: Bool
public extension Bool {
    var not: Bool {
        return !self
    }
    
    var asInt: Int {
        return self ? 1 : 0
    }
}
