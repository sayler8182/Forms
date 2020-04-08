//
//  Array.swift
//  Utils
//
//  Created by Konrad on 3/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: Collection
public extension Collection {
    subscript(safe index: Index) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
    
    subscript(safe index: Index, or default: Element) -> Element {
        return self.indices.contains(index) ? self[index] : `default`
    }
    
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    func count<T>(of type: T.Type) -> Int {
        return self.filter({ $0 is T }).count
    } 
    
    func exclude(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element] {
        return try self.filter { !(try isIncluded($0)) }
    }
    
    func doNotContains(where: (Element) throws -> Bool) rethrows -> Bool {
        return try !self.contains(where: `where`)
    }
}

extension Collection where Element: Equatable {
    func doNotContains(_ element: Element) -> Bool {
        return !self.contains(element)
    }
}

// MARK: Arrray
public extension Array {
    func last(count: Int) -> Array {
        var value = self
        let result = (0..<count)
            .compactMap { _ in return value.popLast() }
        return result.reversed()
    }
    
    func first(count: Int) -> Array {
        return self
            .enumerated()
            .filter { (i, _) in return i < count }
            .compactMap { return $0.element }
    }
}
