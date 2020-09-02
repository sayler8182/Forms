//
//  DatabaseSQLite.swift
//  FormsDemo
//
//  Created by Konrad on 9/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsDatabase
import FormsDatabaseSQLite
import Foundation
import GRDB

// MARK: DemoDatabaseSQLiteProvider
public class DemoDatabaseSQLiteProvider: DatabaseSQLiteProvider {
    private let db: DatabaseQueue!
    
    public required init(path: String,
                         migration: Int) throws {
        self.db = try DatabaseQueue(path: path)
        try self.create([
            DatabaseSQLiteTableConfig(self, migration: migration)
        ])
    }
    
    public func write(_ query: String,
                      _ arguments: [String: Any?]) throws {
        try self.db.write { (db: DatabaseSQLiteDatabase) in
            try db.write(query, arguments)
        }
    }
    
    public func read(_ query: String,
                     _ arguments: [String: Any?]) throws -> [DatabaseSQLiteRow] {
        try self.db.read { (db: DatabaseSQLiteDatabase) in
            try db.read(query, arguments)
        }
    }
    
    public func read(_ query: String,
                     _ arguments: [String: Any?]) throws -> DatabaseSQLiteRow? {
        try self.db.read { (db: DatabaseSQLiteDatabase) in
            try db.read(query, arguments)
        }
    }
} 

// MARK: DatabaseSQLiteQueue
extension GRDB.DatabaseQueue: DatabaseSQLiteQueue {
    public func write(_ updates: (DatabaseSQLiteDatabase) throws -> Void) throws {
        try self.write { (db: Database) in
            try updates(db)
        }
    }
    
    public func read(_ updates: (DatabaseSQLiteDatabase) throws -> [DatabaseSQLiteRow]) throws -> [DatabaseSQLiteRow] {
        try self.read { (db: Database) in
            try updates(db)
        }
    }
    
    public func read(_ updates: (DatabaseSQLiteDatabase) throws -> DatabaseSQLiteRow?) throws -> DatabaseSQLiteRow? {
        try self.read { (db: Database) in
            try updates(db)
        }
    }
}

// MARK: DatabaseSQLiteDatabase
extension GRDB.Database: DatabaseSQLiteDatabase {
    public func write(_ query: String,
                      _ arguments: [String: Any?]) throws {
        let arguments = arguments
            .mapValues { $0 as? DatabaseValueConvertible }
        try self.execute(
            sql: query,
            arguments: StatementArguments(arguments))
    }
    
    public func read(_ query: String,
                     _ arguments: [String: Any?]) throws -> [DatabaseSQLiteRow] {
        let arguments = arguments
            .mapValues { $0 as? DatabaseValueConvertible }
        return try Row.fetchAll(
            self,
            sql: query,
            arguments: StatementArguments(arguments),
            adapter: nil)
    }
    
    public func read(_ query: String,
                     _ arguments: [String: Any?]) throws -> DatabaseSQLiteRow? {
        let arguments = arguments
            .mapValues { $0 as? DatabaseValueConvertible }
        return try Row.fetchOne(
            self,
            sql: query,
            arguments: StatementArguments(arguments),
            adapter: nil)
    }
}

// MARK: DatabaseSQLiteRow
extension GRDB.Row: DatabaseSQLiteRow {
    public func object<T>(key: String,
                          of type: T.Type) throws -> T {
        guard self.columnNames.contains(key) else { throw DatabaseError.row(key) }
        if type == Int.self {
            guard let _value = self[key] as? Int64 else { throw DatabaseError.rowValue(key) }
            return Int(_value) as! T
        } else {
            guard let _value = self[key] as? T else { throw DatabaseError.rowValue(key) }
            return _value
        }
    }
    public func object<T>(key: String,
                          of type: T.Type,
                          or default: T) -> T {
        let value: T? = try? self.object(key: key, of: type)
        return value ?? `default`
    }
}
