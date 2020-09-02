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

// MARK: Mockable
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

// MARK: [Mockable]
public extension Array {
    static func mock<T: Mockable>(count: Int,
                                  of type: T.Type) -> [T] {
        var items: [T] = []
        for _ in 0..<count {
            items.append(type.init(Mock()))
        }
        return items
    }
}
