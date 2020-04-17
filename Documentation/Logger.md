# Logger

Logger is an injectable logger micro service.

## Import

```swift
import Logger
```

## Custom logger

```Swift
class AppLogger: LoggerProtocol {
    func log(_ string: String) {
       print(string)
    }
}
```