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
let logger = Logger()
logger.log("Some data")
```

### Custom logger

```swift
class AppLogger: LoggerProtocol {
    func log(_ string: String) {
       print(string)
    }
}
```