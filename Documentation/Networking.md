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

```Swift
let data = Data()
let request = Request(
    url: "https://postman-echo.com".url,
    method: .POST,
    data: data)
self.call(
    request,
    onSuccess: { (_) in },
    onError: { (_) in },
    onCompletion: { (_, _) in })
```

### Custom headers

```Swift
let request = Request(
    url: "https://postman-echo.com".url,
    method: .POST,
    headers: [ 
        "Language": "en"
    ])
self.call(
    request,
    onSuccess: { (_) in },
    onError: { (_) in },
    onCompletion: { (_, _) in })
```

### Custom provider

```Swift
let request = Request(
    url: "https://postman-echo.com".url,
    method: .GET,
    data: data,
    provider: AppRequestProvider())
self.call(
    request,
    onSuccess: { (_) in },
    onError: { (_) in },
    onCompletion: { (_, _) in })
```

```Swift
class AppRequestProvider: RequestProvider {
    override func setHeaders(_ request: inout Request) {
        let headers = request.headers
        // set additional headers
        request.request.allHTTPHeaderFields = headers
    }
}
```

## Response parser

```Swift
let request = Request(
    url: "https://postman-echo.com".url,
    method: .GET)
self.call(
    request,
    parser: AppResponseParser(),
    onSuccess: { (_) in },
    onError: { (_) in },
    onCompletion: { (_, _) in })
```

```Swift
class AppResponseParser: ResponseParser { 
    override func parseError(data: Data) -> ApiError? {
        // parse error from success response
        return nil
    }
}
```

## Cache

```Swift
let request = Request(
    url: "https://upload.wikimedia.org/wikipedia/commons/0/0f/Welsh_Corgi_Pembroke_WPR_Kamien_07_10_07.jpg".url,
    method: .GET)
self.call(
    request,
    cache: NetworkCache(ttl: 60 * 60),
    onSuccess: { (_) in },
    onError: { (_) in },
    onCompletion: { (_, _) in })
```

## Logger 

```Swift
let request = Request(
    url: "https://postman-echo.com".url,
    method: .GET)
self.call(
    request,
    logger: Logger(),
    onSuccess: { (_) in },
    onError: { (_) in },
    onCompletion: { (_, _) in })
```

## Cancellation


```Swift
let request = Request(
    url: "https://postman-echo.com".url,
    method: .GET)
let task: ApiTask = self.call(
    request,
    onSuccess: { (_) in },
    onError: { (_) in },
    onCompletion: { (_, _) in })
```

```Swift
task.cancel()
```

## SSL Pinning

```Swift
SSLPinning.isEnabled = true
SSLPinning.certificates = [
    Bundle.main.url(forResource: "certificate", withExtension: "cer")
].compactMap { $0 }
```