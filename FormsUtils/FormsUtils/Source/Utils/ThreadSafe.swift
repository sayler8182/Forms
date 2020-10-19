//
//  ThreadSafe.swift
//  FormsUtils
//
//  Created by Konrad on 10/25/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: ThreadSafe
@propertyWrapper
public struct ThreadSafe<T> {
    private let queue: DispatchQueue
    
    private var _object: T?
    
    public init(_ queue: DispatchQueue = .global(),
                _ defaultValue: T? = nil) {
        self.queue = queue
        self._object = defaultValue
    }
    
    public var value: T? {
        get { return self.wrappedValue }
        set { self.wrappedValue = newValue }
    }
    
    public var wrappedValue: T? {
        get { return self.queue.sync { self._object } }
        set { self.queue.sync { self._object = newValue } }
    }
}
