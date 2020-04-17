# Networking

Networking is a HTTP micro service

## Import

```swift
import Networking
```

## Dependencies

```
Injector.framework
Logger.framework
```

## Reachability

Check if has internet connection

```Swift
Reachability.isConnected()
```

## Request

```Swift
let request = Request(
    url: "https://postman-echo.com".url,
    method: .GET)
self.call(
    request,
    onSuccess: { (_) in },
    onError: { (_) in },
    onCompletion: { (_, _) in })
```

### Custom body

### Custom headers

### Custom provider

## Response parser

## Cache

## Logger

## Cancellation

## SSL Pinning