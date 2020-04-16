# Logger

Logger is an injectable logger microservice.

## Import

```swift
import Logger
```

or 

```swift
import Forms
```

## Custom logger

```Swift
class AppLogger: LoggerProtocol {
    func log(_ string: String) {
       print(string)
    }
}
```