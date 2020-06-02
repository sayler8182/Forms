//
//  MockOptions.swift
//  FormsMock
//
//  Created by Konrad on 5/19/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: MockOptions
public enum MockOptions {
    case none
    case length(_ length: Length)
    case nullable(_ chance: Double)
    case quality(_ quality: Quality)
}

public extension MockOptions {
    enum Length {
        case short
        case regular
        case long
    }
    enum Quality {
        case low
        case random
        case high
    }
}

// MARK: [MockOptions]
extension Array where Element == MockOptions {
    var length: MockOptions.Length? {
        return self.compactMap { (item: MockOptions) -> MockOptions.Length? in
            if case let MockOptions.length(length) = item { return length }
            return nil
        }.first
    }
    
    var nullableChance: Double? {
        return self.compactMap { (item: MockOptions) -> Double? in
            if case let MockOptions.nullable(chance) = item { return chance }
            return nil
        }.first
    }
    
    var quality: MockOptions.Quality? {
        return self.compactMap { (item: MockOptions) -> MockOptions.Quality? in
            if case let MockOptions.quality(quality) = item { return quality }
            return nil
        }.first
    }
}
