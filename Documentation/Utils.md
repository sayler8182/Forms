# Utils

Utils is a collection of extension and useful classes

## Import

```swift
import Utils
```

or 

```swift
import Utils
```

## Injections

Utils depends on Injector microservice. To change currency formatting You can inject custom Formatter config.

```Swift
injector.register(NumberFormatProtocol.self) { _ in
    NumberFormat(
        groupingSeparator: "-",
        decimalSeparator: ".")
}
```

## Extensions

UIKit and Foundation classes extensions

## Utils

### AttributedString

Generate clickable NSAttributedString

```Swift
var attributedString = AttributedString()
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

### LoremIpsum

Generates lorem ipsum text

```Swift
let word = LoremIpsum.word
let sentence = LoremIpsum.sentence
let paragraph = LoremIpsum.paragraph(sentences: 10)
let emptyChars = LoremIpsum.empty(chars: 24)
let emptyLines = LoremIpsum.empty(lines: 2)
```