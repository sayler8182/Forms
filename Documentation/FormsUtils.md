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
Date.swift
Dictionary.swift
DispatchQueue.swift
IndexPath.swift
Number.swift
Optional.swift
String.swift
UserDefaults.swift
```

## Utils

Helper classes

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
