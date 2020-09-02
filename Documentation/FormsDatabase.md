# FormsDatabase

FormsDatabase collect protocols for database

## Import

```swift
import FormsDatabase
```

## Dependencies

```
FormsLogger.framework
FormsUtils.framework
```

## Errors

```swift
enum DatabaseError: Error, LocalizedError {
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
```