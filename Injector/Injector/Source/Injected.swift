//
//  Injected.swift
//  Injector
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

@propertyWrapper
public struct Injected<T> {
    private let name: String?
    private var service: T!
    private let injector: Injector
    
    public init(name: String? = nil,
                injector: Injector = .main) {
        self.name = name
        self.injector = injector
    }
    
    public var wrappedValue: T {
        mutating get {
            if self.service == nil {
                self.service = self.injector.resolve(T.self, name: self.name)
            }
            return self.service
        }
        mutating set { self.service = newValue }
    }
    public var projectedValue: Injected<T> {
        get { return self }
        mutating set { self = newValue }
    }
}

@propertyWrapper
public struct OptionalInjected<T> {
    private let name: String?
    private var service: T?
    private let injector: Injector
    
    public init(name: String? = nil,
                injector: Injector = .main) {
        self.name = name
        self.injector = injector
    }
    
    public var wrappedValue: T? {
        mutating get {
            if self.service == nil {
                self.service = self.injector.resolve(T.self, name: self.name)
            }
            return self.service
        }
        mutating set { self.service = newValue }
    }
    public var projectedValue: OptionalInjected<T> {
        get { return self }
        mutating set { self = newValue }
    }
}
