# FormsLogger

FormsLogger is an injectable logger micro service.
By default Logger logs to console and system.

## Import

```swift
import FormsLogger
```

## Usage

### Log

```swift
let logger = ConsoleLogger()
logger.log(.info, "Some data")
```

### Log Type

```swift
enum LogType: Int {
    case info = 0
    case warning = 1
    case error = 2
}
```

### Custom logger

```swift
class AppLogger: Logger {
    func log(_ type: LogType,
             _ string: String) {
       print(string)
    }
}
```