# FormsTransitions

FormsTransitions helper 

## Import

```swift
import FormsTransitions
```

## Dependencies

```
FormsUtils.framework
```

## Usage

### View Interpolation

All views has additional *viewKey* property. View can be interpolated between screens.

```swift
view.viewKey = "contentView"
```

### ViewController

Presented controller must have custom presentation style and set transitioning delegate

```swift
controller.modalPresentationStyle = .custom
controller.transitioningDelegate = coordinator
```

If presented controller conform *TransitionableController* protocol, views between presenting and presented controllers would be interpolated.

Animators

```swift
TransitionControllerSlideHorizontalAnimator
TransitionControllerSlideVerticalAnimator
```

Handle swipe to back interactively

```swift
...
self.edgePanGesture.addTarget(self, action: #selector(handleTransitionBackSwipe))
self.edgePanGesture.edges = .left
self.view.addGestureRecognizer(self.edgePanGesture)
...
    
@objc
func handleTransitionBackSwipe(recognizer: UIScreenEdgePanGestureRecognizer) {
    self.handleTransitionControllerEdgePan(recognizer)
}
```

### NavigationController

Navigation controller must have custom delegate

```swift
controller.delegate = coordinator
```

If navigation controller conform *TransitionableNavigation* protocol, views between controllers would be interpolated.


Animators

```swift
TransitionNavigationSlideHorizontalAnimator
TransitionNavigationSlideVerticalAnimator
```

Handle swipe to back interactively

```swift
...
self.edgePanGesture.addTarget(self, action: #selector(handleTransitionBackSwipe))
self.edgePanGesture.edges = .left
self.view.addGestureRecognizer(self.edgePanGesture)
...
    
@objc
func handleTransitionBackSwipe(recognizer: UIScreenEdgePanGestureRecognizer) {
    self.handleTransitionNavigationEdgePan(recognizer)
}
```