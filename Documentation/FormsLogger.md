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
logger.log(LogType.info, "Some data")
```

### Log Type

```swift
protocol LogTypeProtocol {
    var rawValue: String { get }
}

enum LogType: String, CaseIterable, LogTypeProtocol {
    case info = "_info"
    case warning = "_warning"
    case error = "_error"
}
```

### Custom logger

```swift
class AppLogger: Logger {
    func log(_ type: LogTypeProtocol,
             _ string: String) {
       print(string)
    }
}
```

with custom log type

```swift
enum CustomLogType: String, CaseIterable, LogTypeProtocol {
    case custom_info = "custom_info"
}

let logger = AppLogger()
logger.log(CustomLogType.info, "Some data")
```

### Whitelist

```swift
let logger = ConsoleLogger(whitelist: [LogType.info])
```

by default logger whitelist all *LogType* cases