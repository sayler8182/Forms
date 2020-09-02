//
//  DatabaseSQLiteTable.swift
//  FormsDatabaseSQLite
//
//  Created by Konrad on 9/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsDatabase
import Foundation

// MARK: DatabaseSQLiteRowKey
public protocol DatabaseSQLiteRowKey {
    var rawValue: String { get }
}

// MARK: DatabaseSQLiteRow
public protocol DatabaseSQLiteRow {
    func object<T>(key: String,
                   of type: T.Type) throws -> T
    func object<T>(key: String,
                   of type: T.Type,
                   or default: T) -> T
}

// MARK: DatabaseSQLiteRow
public extension DatabaseSQLiteRow {
    func object<T>(key: DatabaseSQLiteRowKey) throws -> T {
        return try self.object(key: key, of: T.self)
    }
    func object<T>(key: DatabaseSQLiteRowKey,
                   of type: T.Type) throws -> T {
        return try self.object(key: key.rawValue, of: type)
    }
    func object<T>(key: String) throws -> T {
        return try self.object(key: key, of: T.self)
    }
    func object<T>(key: DatabaseSQLiteRowKey,
                   or default: T) -> T {
        return self.object(key: key, of: T.self, or: `default`)
    }
    func object<T>(key: DatabaseSQLiteRowKey,
                   of type: T.Type,
                   or default: T) -> T {
        return self.object(key: key.rawValue, of: type, or: `default`)
    }
    func object<T>(key: String,
                   or default: T) -> T {
        return self.object(key: key, of: T.self, or: `default`)
    }
}

// MARK: DatabaseSQLiteTable
public protocol DatabaseSQLiteTable: DatabaseTableProtocol {
    var name: String { get }
    
    func exist() throws -> Bool
    func info() throws -> String
}

// MARK: DatabaseSQLiteTable
public extension DatabaseSQLiteTable {
    var provider: DatabaseSQLiteProvider! {
        return self._provider as? DatabaseSQLiteProvider
    }
}

// MARK: DatabaseSQLiteTable
public extension DatabaseSQLiteTable {
    func exist() throws -> Bool {
        guard let provider = self.provider else { throw DatabaseError.connection }
        return try DatabaseSQLite.exist(provider: provider, table: self.name)
    }
    
    func info() throws -> String {
        guard let provider = self.provider else { throw DatabaseError.connection }
        return try DatabaseSQLite.info(provider: provider, table: self.name)
    }
 }
