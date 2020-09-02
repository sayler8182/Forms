//
//  DatabaseSQLiteTableConfig.swift
//  FormsDatabaseSQLite
//
//  Created by Konrad on 9/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsDatabase
import Foundation

// MARK: DatabaseSQLiteTableConfig
public extension DatabaseSQLiteTableConfig {
    enum Row: String, DatabaseSQLiteRowKey {
        case id
        case current_migration
    }
}

// MARK: DatabaseSQLiteTableConfig
public class DatabaseSQLiteTableConfig: DatabaseSQLiteTable {
    public var _provider: DatabaseProviderProtocol!
    public let name: String = "forms_config"
    public let newMigration: Int 
    
    public required convenience init(_ provider: DatabaseProviderProtocol!) {
        self.init(provider, migration: 1)
    }
    
    public required init(_ provider: DatabaseProviderProtocol!,
                         migration: Int) {
        self._provider = provider
        self.newMigration = migration
    }
    
    public func create() throws {
        guard let provider = self.provider else { throw DatabaseError.connection }
        try provider.write("""
            CREATE TABLE IF NOT EXISTS \(self.name) (
            \(Row.id) VARCHAR PRIMARY KEY,
            \(Row.current_migration) INTEGER
            )
            """)
    }
    
    public func delete() throws { }
    
    public func setCurrentMigration(_ migration: Int) throws {
        guard let provider = self.provider else { throw DatabaseError.connection }
        try provider.write("""
            INSERT OR REPLACE INTO \(self.name)
            (\(Row.id), \(Row.current_migration)
            VALUES
            ('1', :value)
            """, ["value": migration])
    }
    
    public func getCurrentMigration() throws -> Int {
        guard let provider = self.provider else { throw DatabaseError.connection }
        let row: DatabaseSQLiteRow? = try provider.read(
            "SELECT * FROM \(self.name) LIMIT 1")
        let migration: Int? = try row?.object(key: Row.current_migration)
        return migration ?? 0
    }
}
