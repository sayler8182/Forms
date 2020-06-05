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