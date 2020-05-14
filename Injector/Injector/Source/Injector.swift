//
//  Injector.swift
//  Injector
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: Resolver
public protocol Resolver {
    func resolve<Service>(_ serviceType: Service.Type) -> Service!
    func resolve<Service>(_ serviceType: Service.Type, name: String?) -> Service!
}

// MARK: Assembly
public protocol Assembly {
     func assemble(injector: Injector)
}

// MARK: Injector
public class Injector {
    public static let main: Injector = Injector()
    private var services = [InjectorServiceKey: InjectorServiceProtocol]()
    private let parent: Injector?
    private let scope: InjectorScope
    
    private var currentGraph: GraphIdentifier?
    private let maxResolutionDepth: Int = 200
    private var resolutionDepth = 0
    
    public init(parent: Injector? = nil,
                scope: InjectorScope = InjectorScope.graph,
                registering: (Injector) -> Void = { _ in }) {
        self.parent = parent
        self.scope = scope
        registering(self)
    }
    
    public func assemble(_ assemblies: [Assembly]) {
        for assembly in assemblies {
            assembly.assemble(injector: self)
        }
    }
    
    @discardableResult
    public func register<Service>(_ serviceType: Service.Type,
                                  name: String? = nil,
                                  factory: @escaping (Resolver) -> Any) -> InjectorService<Service> {
        self._register(serviceType, name: name, factory: factory)
    }
    
    public func reset() {
        self.services.removeAll()
    }
    
    public func resetScope(_ scope: InjectorScopeProtocol) {
        self.services.values
            .filter { $0.scope === scope }
            .forEach { $0.storage.instance = nil }
        self.parent?.resetScope(scope)
    }
    
    private func getRegistrations() -> [InjectorServiceKey: InjectorServiceProtocol] {
        var registrations = self.parent?.getRegistrations() ?? [:]
        self.services.forEach { key, value in registrations[key] = value }
        return registrations
    }
}

// MARK: Resolution Depth
extension Injector {
    private func restoreGraph(_ identifier: GraphIdentifier) {
        self.currentGraph = identifier
    }
    
    private func resolutionDepthIncrement() {
        self.parent?.resolutionDepthIncrement()
        if self.resolutionDepth == 0, self.currentGraph == nil {
            self.currentGraph = GraphIdentifier()
        }
        guard self.resolutionDepth < self.maxResolutionDepth else {
            fatalError("Infinite recursive call for circular dependency has been detected.")
        }
        self.resolutionDepth += 1
    }
    
    private func resolutionDepthDecrement() {
        self.parent?.resolutionDepthDecrement()
        self.resolutionDepth -= 1
        guard self.resolutionDepth >= 0 else {
            fatalError("The depth cannot be negative.")
        }
        if self.resolutionDepth == 0 {
            self.resolutionGraphCompleted()
        }
    }
    
    private func resolutionGraphCompleted() {
        self.services.values.forEach {
            $0.storage.resolutioned()
        }
        currentGraph = nil
    }
}

// MARK: Resolver
extension Injector: Resolver {
    public func resolve<Service>(_ name: String? = nil) -> Service! {
        return self.resolve(Service.self, name: name)
    }
    
    public func resolve<Service>(_ serviceType: Service.Type) -> Service! {
        return self.resolve(serviceType, name: nil)
    }
    
    public func resolve<Service>(_ serviceType: Service.Type,
                                 name: String? = nil) -> Service! {
        return self.resolve(name: name) { (factory: (Resolver) -> Any) in factory(self) }
    }
    
    private func resolve<Service, Arguments>(name: String?,
                                             invoker: @escaping ((Arguments) -> Any) -> Any) -> Service! {
        var instance: Service!
        let key = InjectorServiceKey(
            serviceType: Service.self,
            argumentsType: Arguments.self,
            name: name)
        if let service = self.getService(for: key) {
            instance = self.resolve(service: service, invoker: invoker)
        }
        return instance
    }
    
    private func resolve<Service, Factory>(service: InjectorServiceProtocol,
                                           invoker: (Factory) -> Any) -> Service! {
        self.resolutionDepthIncrement()
        defer { self.resolutionDepthDecrement() }
        
        guard let currentGraph = self.currentGraph else {
            fatalError("If accessing container from multiple threads, make sure to use a synchronized resolver.")
        }
        
        if let instance = self.instance(Service.self, from: service, in: currentGraph) {
            return instance
        }
        
        let resolved: Any = invoker(service.factory as! Factory)
        if let instance = self.instance(Service.self, from: service, in: currentGraph) {
            return instance
        }
        service.storage.setInstance(resolved as Any, in: currentGraph)
        
        if let completed = service.inited as? (Resolver, Any) -> Void,
            let resolved = resolved as? Service {
            completed(self, resolved)
        }
        
        return resolved as? Service
    }
    
    private func getService(for key: InjectorServiceKey) -> InjectorServiceProtocol? {
        if let service = self.services[key] {
            return service
        } else {
            return self.parent?.getService(for: key)
        }
    }
    
    private func instance<Service>(_ of: Service.Type,
                                   from service: InjectorServiceProtocol,
                                   in graph: GraphIdentifier) -> Service? {
        if let instance: Any = service.storage.getInstance(from: graph),
            let service: Service = instance as? Service {
            return service
        } else {
            return nil
        }
    }
}

// MARK: Register
extension Injector {
    @discardableResult
    private func _register<Service, Arguments>(_ serviceType: Service.Type,
                                               name: String? = nil,
                                               factory: @escaping (Arguments) -> Any) -> InjectorService<Service> {
        let key = InjectorServiceKey(
            serviceType: Service.self,
            argumentsType: Arguments.self,
            name: name)
        let entry = InjectorService(
            serviceType: serviceType,
            argumentsType: Arguments.self,
            factory: factory,
            scope: self.scope
        )
        self.services[key] = entry
        return entry
    }
}
