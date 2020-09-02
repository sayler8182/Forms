//
//  DatabaseTableProtocol.swift
//  FormsDatabase
//
//  Created by Konrad on 9/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: DatabaseTableProtocol
public protocol DatabaseTableProtocol: class {
    var _provider: DatabaseProviderProtocol! { get set }
    
    init(_ provider: DatabaseProviderProtocol!)
    
    func create() throws
    func delete() throws
}

// MARK: DatabaseTableProtocol
public extension DatabaseTableProtocol {
    init(_ database: DatabaseProtocol!) {
        self.init(database._provider)
    }
}
