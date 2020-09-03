# FormsTodayExtensionKit

FormsTodayExtensionKit is today extension base.

## Import

```swift
import FormsTodayExtensionKit
```

## Dependencies

```
Forms.framework
```

## External dependencies

NotificationCenter.framework

## Usage

### Configuration

You should remove 
- base ViewController
- init storyboard
- init storyboard in Info.plist
and add
- NSExtensionPrincipalClass (eg. FormsExampleTodayExtension.TodayExtensionRootViewController)
- new controller that inherit from FormsTodayExtensionRootViewController
- set root as soon as possible 

```swift
class TodayExtensionRootViewController: FormsTodayExtensionRootViewController {
    override func postInit() {
        self.root = TodayExtensionRoot()
        super.postInit()
    }
}
```

### FormsTodayExtensionRoot

FormsTodayExtensionRoot works like `AppDelegate` is a brain of all extension.

```swift
class TodayExtensionRoot: FormsTodayExtensionRoot {
    private var isConfigured: Bool = false
    
    func configure() {
        guard !self.isConfigured else { return }
        Forms.configure(Injector.main, [
            TodayExtensionAssembly()
        ])
        self.isConfigured = true
    }
}
```

### FormsTodayExtensionViewController

FormsTodayExtensionViewController should be base for all UIViewControllers. All subviews should be added with Anchor framework.

Lifecycle

```swift
func setupView() {
    self.setupConfiguration()
    self.setupTheme()
    
    // HOOKS
    self.setupContent()
    self.setupActions()
    self.setupOther()
    self.setupMock()
    self.setupContext(context)
}
```

Widget

```swift 
var compactHeight: CGFloat { get }
var expandedHeight: CGFloat { get }
    
func widgetPerformUpdate(completionHandler: @escaping ((NCUpdateResult) -> Void))    
func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode,
                                      withMaximumSize maxSize: CGSize) 
```

## App communication

### App open 

```swift
extensionContext.open(self.root.url)
```

### App open with parameters

Parameters should be handled in app with `LaunchOptions`

```swift
let coder: URLCoder = URLCoder()
let url: URL = coder.encode(
    url: self.root.appURL,
    parameters: ["search_text": "Some text"])
extensionContext.open(self.root.url)
```