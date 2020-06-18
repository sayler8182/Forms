# FormsUtils

FormsUtils is a collection of extension and useful classes

## Import

```swift
import FormsUtils
``` 

## Dependencies

```
FormsInjector.framework
```

## Injections

Utils depends on Injector microservice. To change currency formatting You can inject custom Formatter config.

```swift
injector.register(NumberFormatProtocol.self) { _ in
    NumberFormat(
        groupingSeparator: "-",
        decimalSeparator: ".")
}
```

## Extensions

UIKit and Foundation class extensions.

```
Array.swift
Bool.swift
Bundle.swift
CGRect.swift
CGSize.swift
Date.swift
IndexPath.swift
Number.swift
Optional.swift
String.swift
UIActivityIndicatorView.swift
UIAlertViewController.swift
UIButton.swift
UICollectionView.swift
UIColor.swift
UIEdgeInset.swift
UIImage.swift
UIImageView.swift
UILabel.swift
UINavigationController.swift
UIResponder.swift
UIScrollView.swift
UISearchBar.swift
UIStackView.swift
UITableView.swift
UITextField.swift
UIView.swift
UIViewController.swift
```

## Utils

Helper classes

### AppLifecycleable

Available events

```swift
enum AppLifecycleEvent {
    case didEnterBackground
    case willEnterForeground
    case didFinishLaunching
    case didBecomeActive
    case willResignActive
    case didReceiveMemoryWarning
    case willTerminate
    case significantTimeChange
}
```

Usage

```swift
class SomeClass: AppLifecycleable {
    var appLifecycleableEvents: [AppLifecycleEvent] {
        return [.didEnterBackground, .willEnterForeground]
    }
    
    func appLifecycleable(event: AppLifecycleEvent) {
        switch event {
            case .didEnterBackground: // Some action
            case .willEnterForeground: // Some action
            default: break
        }
    }
}
```

Registration

```swift
let object = SomeClass()
object.registerAppLifecycle()
```

or

```swift
let object = SomeClass()
object.unregisterAppLifecycle()
```

By default Forms controllers supports implements *AppLifecycleable*. protocol

### AttributedString

Generate clickable NSAttributedString

```swift
let attributedString = AttributedString()
    .with(color: UIColor.black)
    .with(font: UIFont.systemFont(ofSize: 16))
    .with(string: "Attributed label\n")
    .switchStyle() // change style only for next string
    .with(color: UIColor.lightGray)
    .with(underlineStyle: .single)
    .with(string: "Some NSAttributedString\n")
    .with(string: "Attributed label\n")
    .with(alignment: .center)
    .with(string: "Is centered\n")
    .with(string: "Is still centered\n")
    .with(string: "\n")
    .switchStyle() // change style only for next string
    .with(color: UIColor.red)
    .with(font: UIFont.boldSystemFont(ofSize: 23))
    .with(underlineStyle: .thick)
    .with(string: "Tapable item", onClick: { print("Click") })
    .with(string: "\nSome text")
```

### Debouncer

Allows delay action call

```swift
let debouncer = Debouncer(interval: 0.5)
for i in 0..10 {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
        debouncer.debounce {
            print("test")
        }
    }
}
```

or 

```swift
let debouncer = Debouncer(interval: 0.5)
debouncer.onHandle = { print("test") }
for i in 0..10 {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
        debouncer.debounce()
    }
}
```

will produce output below:

```
test
```

### LoremIpsum

Generates lorem ipsum text

```swift
let word = LoremIpsum.word
let sentence = LoremIpsum.sentence
let paragraph = LoremIpsum.paragraph(sentences: 10)
let emptyChars = LoremIpsum.empty(chars: 24)
let emptyLines = LoremIpsum.empty(lines: 2)
```

### Reference

Utils supports Weak, Unowned and Strong 'functions'. It wraps object and return proper reference in closure.

```swift
reloadButton.onClick = Unowned(self) { (_self) in
    _self.reloadMock()
    _self.reloadData()
}
```

### Pagination

More info is in *Forms* documentation.

### ScrollSteps

Allows you update view in certain offsets

```swift
var scrollTopSteps = ScrollStep(0..<200)
var scrollBottomSteps = ScrollStep(200..<800)
var scrollSteps = ScrollSteps([scrollTopSteps, scrollBottomSteps])
```

ScrollContainer has *scrollSteps* property to manage steps and send *onUpdate* callbacks.

For other scroll you can perform *update* method when offset did change

```swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollSteps.update(scrollView.contentOffset)
}
```

You can use *onUpdateVertical* and *onUpdateHorizontal* callbacks.

```swift
scrollSteps.onUpdateVertical = { (step: ScrollStep, progress: CGFloat) in
    switch step {
    case scrollTopSteps:
        // some changes
    case scrollBottomSteps:
        // some changes
    default: break
    }
}
```

### Storage

Storage keys

```swift
enum StorageKeys: String, StorageKey {
    case token
}
```

Storage wrappers

```swift
@Storage(StorageKeys.token)
let token: String?

@StorageWithDefault(StorageKeys.token, "some_token")
let token: String

@StorageSecure(StorageKeys.token)
let token: String?

@StorageSecureWithDefault(StorageKeys.token)
let token: String
```

Property wrapper read / write

```swift 
let value = token
token = "New value"
```

or standard read / write

```swift
let token = Storage<String>(StorageKeys.token)
let value = token
token.value = "New value"
```

Inject storage container

```swift
injector.register(StorageContainerProtocol.self) { _ in
    StorageUserDefaultsContainer.shared
}
injector.register(StorageSecureContainerProtocol.self) { _ in
    StorageKeychainContainer.shared
}
```

### SVG

Generate UIBezierPath from SVG path.
At this moment SVG doesn't support .svg file format - supports ONLY svg paths.

```swift
let path = "M85 32C115 68 239 170 281 192 311 126 274 43 244 0c97 58 146 167 121 254 28 28 40 89 29 108 -25-45-67-39-93-24C176 409 24 296 0 233c68 56 170 65 226 27C165 217 56 89 36 54c42 38 116 96 161 122C159 137 108 72 85 32z"
```

```
let bezierPath = UIBezierPath(svg: path)
```

or 

```swift
let svg = SVG.Path(path)
let bezierPath = UIBezierPath(svg: svg)
```

By default UIImageView supports SVG and implements *SVGView* protocol

```swift
protocol SVGView: class {
    var svgLayer: CAShapeLayer? { get set }
}
```

```swift
let imageView = UIImageView()
    .with(width: 200, height: 200)
    .with(svg: path)
    .with(svgBackgroundColor: UIColor.white.cgColor)
    .with(svgFillColor: UIColor.blue.cgColor)
    .with(svgStrokeColor: UIColor.black.cgColor)
```