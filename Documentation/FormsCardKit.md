# FormsCardKit

FormsCardKit is tab bar library.

## Import

```swift
import FormsCardKit
```

## Dependencies

```
Forms.framework
```

## Usage

```swift
var demoCardContentController = DemoFormsCardContentController()
var demoCardController = CardController(demoCardContentController)
```

Add to parent  controller

```swift
let overlayView = Components.container.view()
    .with(backgroundColor: Theme.Colors.tertiaryBackground.withAlphaComponent(0.3))
demoCardController.add(to: self, overlay: overlayView)
```

Card appearance progress

```swift
demoCardController.onProgress = { (progress: CGFloat) in }
```

Close from card

```swift
cardController?.close()
```
