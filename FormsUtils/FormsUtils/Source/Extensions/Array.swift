//
//  Array.swift
//  FormsUtils
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
    
    subscript(safe index: Index,
              or default: Element) -> Element {
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
    
    func notContains(where: (Element) throws -> Bool) rethrows -> Bool {
        return try !self.contains(where: `where`)
    }
}

public extension Collection where Element: Equatable {
    var withoutDuplicates: [Element] {
        var result: [Element] = []
        for item in self {
            guard !result.contains(item) else { continue }
            result.append(item)
        }
        return result
    }
    
    func notContains(_ element: Element) -> Bool {
        return !self.contains(element)
    }
}

// MARK: Array
public extension Array {
    func last(count: Int) -> Array {
        let count: Int = Swift.max(0, self.count - count)
        return self
            .enumerated()
            .filter { (i, _) in return i < count }
            .compactMap { return $0.element }
    }
    
    func first(count: Int) -> Array {
        return self
            .enumerated()
            .filter { (i, _) in return i < count }
            .compactMap { return $0.element }
    }
}
