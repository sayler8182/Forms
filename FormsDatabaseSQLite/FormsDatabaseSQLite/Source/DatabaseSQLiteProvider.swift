//
//  DatabaseSQLiteProvider.swift
//  FormsDatabaseSQLite
//
//  Created by Konrad on 9/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsDatabase
import Foundation

// MARK: DatabaseSQLiteProvider
public protocol DatabaseSQLiteProvider: DatabaseProviderProtocol {
    init(path: String,
         migration: Int) throws
    
    func write(_ query: String,
               _ arguments: [String: Any?]) throws
    func read(_ query: String,
              _ arguments: [String: Any?]) throws -> [DatabaseSQLiteRow]
    func read(_ query: String,
              _ arguments: [String: Any?]) throws -> DatabaseSQLiteRow?
}

// MARK: DatabaseSQLiteProvider
public extension DatabaseSQLiteProvider {
    func create(_ tables: [DatabaseSQLiteTable.Type]) throws {
        let tables: [DatabaseSQLiteTable] = tables.map { $0.init(self) }
        try self.create(tables)
    }
    
    func create(_ tables: [DatabaseSQLiteTable]) throws {
        for table in tables {
            try table.create()
        }
    }
    
    func delete(_ tables: [DatabaseSQLiteTable.Type]) throws {
        let tables: [DatabaseSQLiteTable] = tables.map { $0.init(self) }
        try self.delete(tables)
    }
    
    func delete(_ tables: [DatabaseSQLiteTable]) throws {
        for table in tables {
            try table.delete()
        }
    }
}

// MARK: DatabaseSQLiteProvider
public extension DatabaseSQLiteProvider {
    func write(_ query: String) throws {
        try self.write(query, [:])
    }
    
    func read(_ query: String) throws -> [DatabaseSQLiteRow] {
        try self.read(query, [:])
    }
    
    func read(_ query: String) throws -> DatabaseSQLiteRow? {
        try self.read(query, [:])
    }
}

// MARK: DatabaseSQLiteQueue
public protocol DatabaseSQLiteQueue {
    func write(_ action: (DatabaseSQLiteDatabase) throws -> Void) throws
    func read(_ action: (DatabaseSQLiteDatabase) throws -> [DatabaseSQLiteRow]) throws -> [DatabaseSQLiteRow]
    func read(_ action: (DatabaseSQLiteDatabase) throws -> DatabaseSQLiteRow?) throws -> DatabaseSQLiteRow?
}

// MARK: DatabaseSQLiteDatabase
public protocol DatabaseSQLiteDatabase {
    func write(_ query: String,
               _ arguments: [String: Any?]) throws
    func read(_ query: String,
              _ arguments: [String: Any?]) throws -> [DatabaseSQLiteRow]
    func read(_ query: String,
              _ arguments: [String: Any?]) throws -> DatabaseSQLiteRow?
}
