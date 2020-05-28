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

### LoremIpsum

Generates lorem ipsum text

```swift
let word = LoremIpsum.word
let sentence = LoremIpsum.sentence
let paragraph = LoremIpsum.paragraph(sentences: 10)
let emptyChars = LoremIpsum.empty(chars: 24)
let emptyLines = LoremIpsum.empty(lines: 2)
```