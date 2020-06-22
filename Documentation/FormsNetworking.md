# FormsNetworking

FormsNetworking is a HTTP micro service

## Import

```swift
import FormsNetworking
```

## Dependencies

```
FormsInjector.framework
FormsLogger.framework
```

## Usage

### Reachability

Check if has internet connection

```swift
NetworkReachability.isConnected
```

### Request

Class should inheritance *NetworkMethod* class

```swift
class DemoNetworkMethod: NetworkMethod {
    var url: URL! = "https://postman-echo.com/get?foo1=bar1&foo2=bar2".url
}

DemoNetworkMethod()
    .call(
        request,
        onSuccess: { (_) in },
        onError: { (_) in },
        onCompletion: { (_, _) in })
```

### Custom body and headers

```swift
class DemoNetworkMethod: NetworkMethod {
    class Content: NetworkMethodContent {
        var token: String?

        var parameters: [String: Any]? {
            var parameters: [String: Any?] = [:]
            parameters["token"] = token
            return parameters
        }
        var headers: [String: String?]? {
            var headers: [String: String] = [:]
            headers["language"] = "en"
            return headers
        }
    }

    var content: NetworkMethodContent?
    var url: URL! = "https://postman-echo.com".url
    var method: HTTPMethod = .POST

    init(_ content: Content) {
        self.content = content
    }
}
```

### Custom interceptor

```swift
class DemoNetworkMethod: NetworkMethod {
    var url: URL! = "https://postman-echo.com".url
    var interceptor: NetworkRequestInterceptor? = AppNetworkRequestInterceptor()
} 
```

```swift
class AppNetworkRequestInterceptor: NetworkRequestInterceptor {
    override func setHeaders(_ request: Request) {
        let headers = request.headers
        /* set additional headers */
        request.request.allHTTPHeaderFields = headers
    }
}
```

### Response parser

```swift
class DemoNetworkMethod: NetworkMethod {
    var url: URL! = "https://postman-echo.com".url
    var parser: NetworkResponseParser? = AppNetworkResponseParser()
} 
```

```swift
class AppNetworkResponseParser: NetworkResponseParser { 
    override func parseError(data: Data) -> NetworkError? {
        // parse error from success response
        return nil
    }
}
```

### Cache and logger

```swift
DemoNetworkMethod()
    .with(logger: VoidLogger())
    .with(cache: NetworkTmpCache(ttl: 60 * 60))
    .call(
        request,
        onSuccess: { (_) in },
        onError: { (_) in },
        onCompletion: { (_, _) in })
```

### Cancellation


```swift
let request = DemoNetworkMethod()
    .call(
        request,
        onSuccess: { (_) in },
        onError: { (_) in },
        onCompletion: { (_, _) in })
```

```swift
task.cancel()
```

### SSL Pinning

```swift
NetworkPinning.isEnabled = true
NetworkPinning.certificates = [
    Bundle.main.url(forResource: "certificate", withExtension: "cer")
].compactMap { $0 }
```
