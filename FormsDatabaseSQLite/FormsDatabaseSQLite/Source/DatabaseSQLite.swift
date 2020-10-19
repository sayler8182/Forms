//
//  DatabaseSQLite.swift
//  FormsDatabaseSQLite
//
//  Created by Konrad on 9/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsDatabase
import FormsLogger
import FormsUtils
import Foundation

// MARK: DatabaseSQLite
public class DatabaseSQLite: DatabaseProtocol {
    public var _provider: DatabaseProviderProtocol!
    public let version: Version
    public var migration: Int {
        let config = DatabaseSQLiteTableConfig(self.provider)
        let currentMigration: Int? = try? config.getCurrentMigration()
        return currentMigration ?? -1
    }
    public var isConnected: Bool {
        return self.provider.isNotNil
    }
    
    public var path: String!
    public var provider: DatabaseSQLiteProvider! {
        return self._provider as? DatabaseSQLiteProvider
    }
  
    public convenience init() {
        self.init(version: "0.0.0")
    }
    
    public init(version: String) {
        self.version = Version(version)
    }
    
    public init(version: Version) {
        self.version = version
    }
    
    public func configure(name: String = "db") {
        let directory: [URL] = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let path: String = directory.first?.appendingPathComponent("FormsDatabase").path else { return }
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            self.logger?.log(LogType.error, "[DB]: Can't create database directory:\n\(path)")
        }
        let dbPath: String = path.appending("/\(name).sqlite")
        self.path = dbPath
    }
    
    public func remove(name: String = "db") {
        let directory: [URL] = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let path: String = directory.first?.appendingPathComponent("FormsDatabase").path else { return }
        let dbPath: String = path.appending("/\(name).sqlite")
        try? FileManager.default.removeItem(atPath: dbPath)
    }
    
    public func connect(to provider: DatabaseProviderProtocol.Type,
                        migration: Int) throws {
        let path: String = self.path ?? ""
        self._provider = try provider.init(path: path, migration: migration)
        if self.provider == nil {
            self.logger?.log(LogType.error, "[DB]: Incorrect provider type:\n\(path)")
            throw DatabaseError.connectionInit
        }
        if !FileManager.default.isReadableFile(atPath: path) {
            self.logger?.log(LogType.error, "[DB]: Database unreadable:\n\(path)")
            throw DatabaseError.connectionInit
        }
        if !FileManager.default.isWritableFile(atPath: path) {
            self.logger?.log(LogType.error, "[DB]: Database unwriteable:\n\(path)")
            throw DatabaseError.connectionInit
        }
    }
    
    public func disconnect() {
        self._provider = nil
    }
}

// MARK: CRUD
public extension DatabaseSQLite {
    func create(_ tables: [DatabaseSQLiteTable]) throws {
        try self.provider.create(tables)
    }
    
    func create(_ tables: [DatabaseSQLiteTable.Type]) throws {
        try self.provider.create(tables)
    }
    
    func delete(_ tables: [DatabaseSQLiteTable]) throws {
        try self.provider.delete(tables)
    }
    
    func delete(_ tables: [DatabaseSQLiteTable.Type]) throws {
        try self.provider.delete(tables)
    }
    
    func write(_ query: String,
               _ arguments: [String: Any?] = [:]) throws {
        return try self.provider.write(query, arguments)
    }
    
    func read(_ query: String,
              _ arguments: [String: Any?] = [:]) throws -> [DatabaseSQLiteRow] {
        return try self.provider.read(query, arguments)
    }
    
    func read(_ query: String,
              _ arguments: [String: Any?] = [:]) throws -> DatabaseSQLiteRow? {
        return try self.provider.read(query, arguments)
    }
}

// MARK: DatabaseSQLite
public extension DatabaseSQLite {
    func tables() throws -> [String] {
        guard let provider = self.provider else { throw DatabaseError.connection }
        let rows: [DatabaseSQLiteRow] = try provider.read("""
            SELECT name FROM sqlite_master
            WHERE type IN ('table','view')
            AND name NOT LIKE 'sqlite_%'
            ORDER BY 1
            """)
        return try rows.compactMap { try $0.object(key: "name", of: String.self) }
    }
    
    func info() throws -> String {
        var info: String = ""
        let tables: [String] = try self.tables()
        info += "=========================\n"
        info += "DATABASE STRUCTURE\n"
        info += "=========================\n"
        info += try tables
            .map { try Self.info(provider: self.provider, table: $0) }
            .joined(separator: "\n-------------------------\n")
        info += "\n========================="
        return info
    }
    
    static func exist(provider: DatabaseSQLiteProvider,
                      table: String) throws -> Bool {
        let rows: [DatabaseSQLiteRow] = try provider.read(
            "PRAGMA table_info(\(table))")
        return try rows.contains(where: { try $0.object(key: "name", of: String.self) == table })
    }
    
    static func info(provider: DatabaseSQLiteProvider,
                     table: String) throws -> String {
        let rows: [DatabaseSQLiteRow] = try provider.read(
            "PRAGMA table_info(\(table))")
        var info: String = ""
        info += "\(table)\n"
        info += "-------------------------\n"
        info += "cid\t|  name\t|  type\t|  notnull\t|  pk\n"
        info += rows.map {
            var string: String = ""
            string += "\($0.object(key: "cid", of: Int64.self, or: 0))\t|  "
            string += "\($0.object(key: "name", of: String.self, or: ""))\t|  "
            string += "\($0.object(key: "type", of: String.self, or: ""))\t|  "
            string += "\($0.object(key: "notnull", of: Int64.self, or: 0))\t|  "
            string += "\($0.object(key: "pk", of: Int64.self, or: 0))"
            return string
        }
        .joined(separator: "\n")
        return info
    }
}

// MARK: DatabaseSQLiteModel
public protocol DatabaseSQLiteModel {
    init(_ row: DatabaseSQLiteRow) throws
}
