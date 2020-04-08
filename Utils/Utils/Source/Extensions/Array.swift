//
//  Array.swift
//  Utils
//
//  Created by Konrad on 3/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

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
