# FormsToastKit

FormsToastKit is toast library.

## Import

```swift
import FormsToastKit
```

## Dependencies

```
Forms.framework
```

## Usage

Toast can be shown on every UIViewController (also UINavigationController)

```swift
Toast.new()
    .with(title: "Some message"))
    .show(in: controller)
```

or

```swift
Toast.new(of: CustomToastView.self)
    .show(in: controller)
```

Position allows you to change toast position

```swift
enum ToastPosition {
    case top
    case bottom
}
```

```swift
Toast.new()
    .with(position: .bottom))
    .with(title: "Some message"))
    .show(in: controller)
```

Style allows you to change toast presentation style

```swift
enum ToastStyleType {
    case info
    case success
    case error
}
```

```swift
Toast.new()
    .with(style: .info))
    .with(title: "Some message"))
    .show(in: controller)
```

or 

```swift
Toast.error()
    .with(title: "Some message"))
    .show(in: controller)
```

Custom configuration

```swift
Injector.main.register(ConfigurationToastProtocol.self) { _ in
    return Configuration.Toast(
        backgroundColor: .init(
            info: UIColor.black,
            success: UIColor.green,
            error: UIColor.red)
    )
}
```

Custom toast implementation

```swift
class CustomToastView: ToastView {
    override func add(to parent: UIView) { }
    override func show(animated: Bool,
                       completion: ((Bool) -> Void)? = nil) { }
    override func hide(animated: Bool,
                       completion: ((Bool) -> Void)? = nil) { }
}
```