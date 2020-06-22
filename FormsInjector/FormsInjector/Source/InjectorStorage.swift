//
//  InjectorStorage.swift
//  FormsInjector
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: GraphIdentifier
public final class GraphIdentifier { }
extension GraphIdentifier: Equatable, Hashable {
    public static func == (lhs: GraphIdentifier, rhs: GraphIdentifier) -> Bool {
        return lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
}

// MARK: InjectorStorage
public protocol InjectorStorage: AnyObject {
    var instance: Any? { get set }
    
    func resolutioned()
    func getInstance(from graph: GraphIdentifier) -> Any?
    func setInstance(_ : Any?,
                     in graph: GraphIdentifier)
}

public extension InjectorStorage {
    func resolutioned() { }
    func getInstance(from graph: GraphIdentifier) -> Any? {
        return self.instance
    }
    func setInstance(_ instance: Any?,
                     in  graph: GraphIdentifier) {
        self.instance = instance
    }
}

// MARK: GraphStorage
public final class GraphStorage: InjectorStorage {
    private var instances: [GraphIdentifier: Weak<AnyObject>] = [:]
    public var instance: Any?
    private var lock: NSLock = NSLock()
    
    public init() {}
    
    public func resolutioned() {
        self.instance = nil
    }
    
    public func getInstance(from graph: GraphIdentifier) -> Any? {
        self.lock.lock()
        let instance: Any? = self.instances[graph]?.value
        self.lock.unlock()
        return instance
    }
    
    public func setInstance(_ instance: Any?,
                            in graph: GraphIdentifier) {
        self.lock.lock()
        self.instance = instance
        
        if self.instances[graph] == nil {
            self.instances[graph] = Weak()
        }
        self.instances[graph]?.value = instance as AnyObject?
        self.lock.unlock()
    }
}

// MARK: PermanentStorage
public final class PermanentStorage: InjectorStorage {
    public var instance: Any?
    
    public init() {}
}

// MARK: TransientStorage
public final class TransientStorage: InjectorStorage {
    public var instance: Any? {
        get { return nil }
        set { _ = newValue }
    }
    
    public init() {}
}

// MARK: WeakStorage
public final class WeakStorage: InjectorStorage {
    private var _instance = Weak<AnyObject>()
    public var instance: Any? {
        get { return self._instance.value as Any }
        set { self._instance.value = newValue as AnyObject }
    }
    
    public init() {}
}

// MARK: CompositeStorage
public final class CompositeStorage: InjectorStorage {
    private let components: [InjectorStorage]
    
    public var instance: Any? {
        get { return self.components.compactMap { $0.instance }.first }
        set { self.components.forEach { $0.instance = newValue } }
    }
    
    public init(_ components: [InjectorStorage]) {
        self.components = components
    }
    
    public func resolutioned() {
        self.components.forEach { $0.resolutioned() }
    }
    
    public func getInstance(from graph: GraphIdentifier) -> Any? {
        return self.components.compactMap { $0.getInstance(from: graph) }.first
    }
    
    public func setInstance(_ instance: Any?,
                            in graph: GraphIdentifier) {
        self.components.forEach { $0.setInstance(instance, in: graph) }
    }
}

// MARK: Weak
private class Weak<T: AnyObject> {
    private weak var _value: T?
    var value: T? {
        get { return self._value }
        set { self._value = newValue }
    }
    
    init(_ value: T? = nil) {
        self._value = value
    }
}
