//
//  DatabaseProtocol.swift
//  FormsDatabase
//
//  Created by Konrad on 9/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import FormsLogger
import FormsUtils
import Foundation

// MARK: DatabaseError
public enum DatabaseError: Error, LocalizedError {
    case connectionInit
    case connection
    case row(String)
    case rowValue(String)
     
    public var errorDescription: String? {
        switch self {
        case .connectionInit: return "Can't connect"
        case .connection: return "Database is not connected"
        case .row(let column): return "Column doesn't exist (\(column))"
        case .rowValue(let column): return "Incorrect column value (\(column))"
        }
    }
}

// MARK: DatabaseProtocol
public protocol DatabaseProtocol {
    var _provider: DatabaseProviderProtocol! { get }
    var version: Version { get }
    var migration: Int { get }
    var isConnected: Bool { get }
    
    func configure(name: String)
    func remove(name: String)
    func connect(to provider: DatabaseProviderProtocol.Type,
                 migration: Int) throws
    func disconnect()
}

public extension DatabaseProtocol {
    func configure() {
        self.configure(name: "db")
    }
    func remove() {
        self.remove(name: "db")
    }
}

// MARK: DatabaseProtocol
public extension DatabaseProtocol {
    var logger: Logger? {
        return Injector.main.resolveOrDefault("FormsDatabase")
    }
}
