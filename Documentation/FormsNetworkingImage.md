# FormsNetworkingImage

FormsNetworkingImage is a HTTP micro service for images

## Import

```swift
import FormsNetworkingImage
```

## Dependencies

```
FormsInjector.framework
FormsLogger.framework
FormsNetworking.framework
```

## Usage

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