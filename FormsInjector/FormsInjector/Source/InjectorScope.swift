//
//  InjectorScope.swift
//  FormsInjector
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: InjectorScopeProtocol
public protocol InjectorScopeProtocol: AnyObject {
    func makeStorage() -> InjectorStorage
}

// MARK: InjectorScope
public class InjectorScope: InjectorScopeProtocol, CustomStringConvertible {
    private let storageFactory: () -> InjectorStorage
    private let parent: InjectorScopeProtocol?
    public let description: String
    
    private init(storageFactory: @escaping () -> InjectorStorage,
                 parent: InjectorScopeProtocol? = nil,
                 description: String) {
        self.storageFactory = storageFactory
        self.parent = parent
        self.description = description
    }
    
    public func makeStorage() -> InjectorStorage {
        let storage: InjectorStorage = self.storageFactory()
        guard let parent = self.parent else {
            return storage
        }
        return CompositeStorage([
            storage,
            parent.makeStorage()
        ])
    }
}

public extension InjectorScope {
    static let transient = InjectorScope(
        storageFactory: TransientStorage.init,
        description: "transient")
    
    static let graph = InjectorScope(
        storageFactory: GraphStorage.init,
        description: "graph")
    
    static let container = InjectorScope(
        storageFactory: PermanentStorage.init,
        description: "container")
    
    static let weak = InjectorScope(
        storageFactory: WeakStorage.init,
        parent: InjectorScope.graph,
        description: "weak")
}
