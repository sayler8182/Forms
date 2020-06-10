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
let request = NetworkRequest(url: "https://postman-echo.com".url)
    .with(method: .GET)
self.call(
    request,
    onSuccess: { (_) in },
    onError: { (_) in },
    onCompletion: { (_, _) in })
```

### Custom body

```swift
let data = Data()
let request = NetworkRequest(url: "https://postman-echo.com".url)
    .with(method: .POST)
    .with(body: data)
self.call(
    request,
    onSuccess: { (_) in },
    onError: { (_) in },
    onCompletion: { (_, _) in })
```

### Custom headers

```swift
let request = NetworkRequest(url: "https://postman-echo.com".url)
    .with(method: .POST)
    .with(headers: [ 
        "Language": "en"
    ]])
self.call(
    request,
    onSuccess: { (_) in },
    onError: { (_) in },
    onCompletion: { (_, _) in })
```

### Custom interceptor

```swift
let request = NetworkRequest(url: "https://postman-echo.com".url)
    .with(method: .GET)
    .with(body: data)
    .with(interceptor: AppNetworkRequestInterceptor())
self.call(
    request,
    onSuccess: { (_) in },
    onError: { (_) in },
    onCompletion: { (_, _) in })
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
let request = NetworkRequest(url: "https://postman-echo.com".url)
    with(method: .GET)
self.call(
    request,
    parser: AppNetworkResponseParser(),
    onSuccess: { (_) in },
    onError: { (_) in },
    onCompletion: { (_, _) in })
```

```swift
class AppNetworkResponseParser: NetworkResponseParser { 
    override func parseError(data: Data) -> NetworkError? {
        // parse error from success response
        return nil
    }
}
```

### Cache

```swift
let request = NetworkRequest(url: "https://upload.wikimedia.org/wikipedia/commons/0/0f/Welsh_Corgi_Pembroke_WPR_Kamien_07_10_07.jpg".url)
    .with(method: .GET)
self.call(
    request,
    cache: NetworkTmpCache(ttl: 60 * 60),
    onSuccess: { (_) in },
    onError: { (_) in },
    onCompletion: { (_, _) in })
```

### Logger 

```swift
let request = NetworkRequest(url: "https://postman-echo.com".url)
    .with(method: .GET)
self.call(
    request,
    logger: ConsoleLogger(),
    onSuccess: { (_) in },
    onError: { (_) in },
    onCompletion: { (_, _) in })
```

### Cancellation


```swift
let request = NetworkRequest(url: "https://postman-echo.com".url)
    .with(method: .GET)
let task: NetworkTask = self.call(
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

### Images

```swift
let networkImages = NetworkImages()
let request = NetworkImageRequest(
    url: "https://upload.wikimedia.org/wikipedia/commons/0/0f/Welsh_Corgi_Pembroke_WPR_Kamien_07_10_07.jpg".url)
networkImages.image(
    request: request,
    onProgress: { (_, _, _) in },
    onSuccess: { _ in },
    onError: { _ in },
    onCompletion: { (_, _) in })
request.cancel()
```

or

```swift
let request = NetworkImageRequest(
    url: "https://upload.wikimedia.org/wikipedia/commons/0/0f/Welsh_Corgi_Pembroke_WPR_Kamien_07_10_07.jpg".url)
imageView.setImage(request: request)
request.cancel()
```

or 

```swift 
let string = "https://upload.wikimedia.org/wikipedia/commons/0/0f/Welsh_Corgi_Pembroke_WPR_Kamien_07_10_07.jpg"
imageView.setImage(request: string)
request.cancel()
```