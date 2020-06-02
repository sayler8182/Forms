# FormsPagerKit

FormsPagerKit is pager library.

## Import

```swift
import FormsPagerKit
```

## Dependencies

```
Forms.framework
```

## Usage

```swift
override func setupItems() {
    super.setupItems()
    self.setItems([
        PagerItem(
            viewController: { UIViewController() }
            title: "First",
            onSelect: { _ in }),
        PagerItem(
            viewController: { UIViewController() }
            title: "Second is longer",
            onSelect: { _ in }),
    ])
```

You can show or hide top bar

```swift
func showTopBar(animated: Bool = true,
                completion: ((Bool) -> Void)? = nil) {
func hideTopBar(animated: Bool = true,
                completion: ((Bool) -> Void)? = nil) {
```

and page control

```swift
func showPageControl(animated: Bool = true,
                    completion: ((Bool) -> Void)? = nil) {
func hidePageControl(animated: Bool = true,
                    completion: ((Bool) -> Void)? = nil) {
```