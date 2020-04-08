//
//  Optional.swift
//  Utils
//
//  Created by Konrad on 3/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

public extension Optional {
    var isNil: Bool {
        switch self {
        case .none: return true
        case .some: return false
        }
    }
    
    var isNotNil: Bool {
        return !self.isNil
    }
    
    func or(_ defaultValue: Wrapped) -> Wrapped {
        switch self {
        case .none: return defaultValue
        case .some(let value): return value
        }
    }
}
