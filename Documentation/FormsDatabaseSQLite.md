# FormsDatabaseSQLite

FormsDatabaseSQLite handle SQLite database

## Import

```swift
import FormsDatabase
```

## Dependencies

```
FormsLogger.framework
FormsUtils.framework
```

## External dependencies

```
GRDB.swift.framework
```

## Integration

SQLite - GRDB.swift or FMDB - framework should be integrated in main project. 
To install GRDB You should download GRDB main project, run GRDBiOS Target for simulator and generic devices and run merge_architectures script.

## Usage

### Configuration

```swift
class DemoDatabaseSQLiteProvider: DatabaseSQLiteProvider {
    /* ... */
}
```

Example implementation is [here](../FormsDemo/FormsDemo/Source/Implementations/DatabaseSQLite.swift).

### Connection

```swift
let database = DatabaseSQLite(version: "0.0.0")
database.configure(name: "db")
database.connect(
    to: DemoDatabaseSQLiteProvider.self,
    migration: 0)
database.create([
    DatabaseSQLiteTableModels.self
])
```

### Table

```swift
extension DatabaseSQLiteTableModels {
    enum Row: String, DatabaseSQLiteRowKey {
        case id
        case name
        case description
        case price
        case count
    }
}

class DatabaseSQLiteTableModels: DatabaseSQLiteTable {
    var _provider: DatabaseProviderProtocol!
    let name: String = "forms_models"
    
    required init(_ provider: DatabaseProviderProtocol!) {
        self._provider = provider
    }
    
    func create() throws {
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
    
    func delete() throws {
        guard let provider = self.provider else { throw DatabaseError.connection }
        try provider.write("DROP TABLE IF NOT EXISTS \(self.name)")
    }
}
```

### Models

```swift
struct DemoSQLiteModel: DatabaseSQLiteModel {
    let id: String
    let name: String
    let description: String?
    let price: Double
    let count: Int

    init(_ row: DatabaseSQLiteRow) throws {
        self.id = try row.object(key: DatabaseSQLiteTableModels.Row.id, of: String.self)
        self.name = try row.object(key: DatabaseSQLiteTableModels.Row.name, of: String.self)
        self.description = try row.object(key: DatabaseSQLiteTableModels.Row.description, of: String?.self)
        self.price = try row.object(key: DatabaseSQLiteTableModels.Row.price, of: Double.self)
        self.count = try row.object(key: DatabaseSQLiteTableModels.Row.count, of: Int.self)
    } 
}
```

### Insert

```swift
extension DatabaseSQLiteTableModels {
    func insertModels(_ models: [DemoSQLiteModel]) throws {
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
}
```

### Select

```swift 
extension DatabaseSQLiteTableModels {
    func selectModels() throws -> [DemoSQLiteModel] {
        guard let provider = self.provider else { throw DatabaseError.connection }
        let rows: [DatabaseSQLiteRow] = try provider.read(
            "SELECT * FROM \(self.name)")
        return try rows.map { try DemoSQLiteModel($0) }
    } 
}
```

### Remove

```swift 
extension DatabaseSQLiteTableModels {
    func removeModels(_ models: [DemoSQLiteModel]) throws {
        guard let provider = self.provider else { throw DatabaseError.connection }
        for model in models {
            try provider.write("""
                DELETE FROM \(self.name)
                WHERE \(Row.id) == :id
                """, [ "id": model.id ])
        }
    }
}
```


