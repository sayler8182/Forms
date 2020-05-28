//
//  Mockable.swift
//  FormsMock
//
//  Created by Konrad on 5/19/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: Mockable
public protocol Mockable {
    init(_ mock: Mock)
}

public extension Mockable {
    static func mock() -> Self {
        return Self.mock(Self.self)
    }
    
    static func mock<T: Mockable>() -> T {
        return Self.mock(T.self)
    }
    
    static func mock<T: Mockable>(_ type: T.Type) -> T {
        return type.init(Mock())
    }
}
