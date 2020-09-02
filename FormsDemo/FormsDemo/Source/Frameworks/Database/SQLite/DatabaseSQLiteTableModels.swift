//
//  DatabaseSQLiteTableModel.swift
//  FormsDemo
//
//  Created by Konrad on 9/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsDatabase
import FormsDatabaseSQLite
import Foundation

// MARK: DatabaseSQLiteTableModels
public extension DatabaseSQLiteTableModels {
    enum Row: String, DatabaseSQLiteRowKey {
        case id
        case name
        case description
        case price
        case count
    }
}

// MARK: DatabaseSQLiteTableModels
public class DatabaseSQLiteTableModels: DatabaseSQLiteTable {
    public var _provider: DatabaseProviderProtocol!
    public let name: String = "forms_models"
    
    public required init(_ provider: DatabaseProviderProtocol!) {
        self._provider = provider
    }
    
    public func create() throws {
        guard let provider = self.provider else { throw DatabaseError.connection }
        try provider.write("""
            CREATE TABLE IF NOT EXISTS \(self.name) (
            \(Row.id) VARCHAR PRIMARY KEY,
            \(Row.name) VARCHAR,
            \(Row.description) VARCHAR,
            \(Row.price) REAL,
            \(Row.count) INTEGER
            )
            """)
    }
    
    public func delete() throws {
        guard let provider = self.provider else { throw DatabaseError.connection }
        try provider.write("DROP TABLE IF NOT EXISTS \(self.name)")
    }
    
    public func insertModels(_ models: [DemoSQLiteModel]) throws {
        guard let provider = self.provider else { throw DatabaseError.connection }
        for model in models {
            try provider.write("""
                INSERT OR REPLACE INTO \(self.name)
                (\(Row.id), \(Row.name), \(Row.description), \(Row.price), \(Row.count))
                VALUES
                (:id, :name, :description, :price, :count)
                """, [
                    "id": model.id,
                    "name": model.name,
                    "description": model.description,
                    "price": model.price,
                    "count": model.count
            ])
        }
    }
    
    public func selectModels() throws -> [DemoSQLiteModel] {
        guard let provider = self.provider else { throw DatabaseError.connection }
        let rows: [DatabaseSQLiteRow] = try provider.read(
            "SELECT * FROM \(self.name)")
        return try rows.map { try DemoSQLiteModel($0) }
    }
    
    public func removeModels(_ models: [DemoSQLiteModel]) throws {
        guard let provider = self.provider else { throw DatabaseError.connection }
        for model in models {
            try provider.write("""
                DELETE FROM \(self.name)
                WHERE \(Row.id) == :id
                """, [ "id": model.id ])
        }
    }
}
