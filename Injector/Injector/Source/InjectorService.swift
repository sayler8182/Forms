//
//  Injector.swift
//  Forms
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation
 
// MARK: InjectorServiceKey
struct InjectorServiceKey {
    let serviceType: Any.Type
    let argumentsType: Any.Type
    let name: String?
    
    init(serviceType: Any.Type,
         argumentsType: Any.Type,
         name: String? = nil) {
        self.serviceType = serviceType
        self.argumentsType = argumentsType
        self.name = name
    }
}

// MARK: Hashable
extension InjectorServiceKey: Hashable {
    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self.serviceType).hash(into: &hasher)
        ObjectIdentifier(self.argumentsType).hash(into: &hasher)
        self.name?.hash(into: &hasher)
    }
    
    public static func == (lhs: InjectorServiceKey, rhs: InjectorServiceKey) -> Bool {
        return lhs.serviceType == rhs.serviceType
            && lhs.argumentsType == rhs.argumentsType
            && lhs.name == rhs.name
    }
}

// MARK: InjectorServiceProtocol
protocol InjectorServiceProtocol: AnyObject {
    var serviceType: Any.Type { get }
    var argumentsType: Any.Type { get }
    var factory: Any { get }
    var scope: InjectorScopeProtocol { get }
    var storage: InjectorStorage { get }
    var inited: Any? { get }
}

// MARK: InjectorService
public final class InjectorService<Service>: InjectorServiceProtocol {
    fileprivate var initedActions: [(Resolver, Service) -> Void] = []
    let serviceType: Any.Type
    let argumentsType: Any.Type
    let factory: Any
    var scope: InjectorScopeProtocol = InjectorScope.graph
    
    lazy var storage: InjectorStorage = self.scope.makeStorage()
    
    var inited: Any? {
        guard !self.initedActions.isEmpty else { return nil }
        return { [weak self] (resolver: Resolver, service: Any) -> Void in
            guard let `self` = self else { return }
            self.initedActions.forEach { $0(resolver, service as! Service) }
        }
    }
    
    init(serviceType: Service.Type,
         argumentsType: Any.Type,
         factory: Any) {
        self.serviceType = serviceType
        self.argumentsType = argumentsType
        self.factory = factory
    }
    
    convenience init(serviceType: Service.Type,
                     argumentsType: Any.Type,
                     factory: Any,
                     scope: InjectorScope) {
        self.init(serviceType: serviceType, argumentsType: argumentsType, factory: factory)
        self.scope = scope
    }
    
    @discardableResult
    public func inScope(_ scope: InjectorScopeProtocol) -> Self {
        self.scope = scope
        return self
    }
    
    @discardableResult
    public func inited(_ completed: @escaping (Resolver, Service) -> Void) -> Self {
        self.initedActions.append(completed)
        return self
    }
}
