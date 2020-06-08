# FormsHomeShortcuts

FormsHomeShortcuts is shortcuts helper.

## Import

```swift
import FormsHomeShortcuts
```

## Usage

### Keys definition

```swift
public enum DemoHomeShortcutsKeys: String, CaseIterable, HomeShortcutsKeysProtocol {
    case option1
    case option2
    
    public var item: HomeShortcutItem {
        let bundleIdentifier: String = Bundle.main.bundleIdentifier ?? ""
        switch self {
        case .option1:
            return HomeShortcutItem(
                bundleIdentifier: bundleIdentifier,
                code: "opt_1",
                title: "Title option 1",
                subtitle: "Subtitle option 1",
                icon: UIApplicationShortcutIcon(systemImageName: "square.and.arrow.up"),
                userInfo: nil)
        case .option2:
            return HomeShortcutItem(
                bundleIdentifier: bundleIdentifier,
                code: "opt_2",
                title: "Title option 2",
                subtitle: "Subtitle option 2",
                icon: UIApplicationShortcutIcon(systemImageName: "paperplane.fill"),
                userInfo: nil)
        }
    }
}
```

### Configuration

```swift
let homeShortcuts = HomeShortcuts()
homeShortcuts.add(keys: DemoHomeShortcutsKeys.allCases)
```

```swift
let homeShortcuts = HomeShortcuts()
homeShortcuts.removeAll()
```

### Launch for AppDelegate

In app delegate didFinishLaunchingWithOptions

```swift
homeShortcuts.launch(launchOptions)
```

and

```swift
func application(_ application: UIApplication,
                 performActionFor shortcutItem: UIApplicationShortcutItem,
                 completionHandler: @escaping (Bool) -> Void) {
    homeShortcuts.launch(shortcutItem)
    completionHandler(true)
}
```

### Launch for SceneDelegate

In scene delegate connectionOptions

```swift
homeShortcuts.launch(connectionOptions.shortcutItem)
```

and

```swift
func windowScene(_ windowScene: UIWindowScene,
                 performActionFor shortcutItem: UIApplicationShortcutItem,
                 completionHandler: @escaping (Bool) -> Void) {
    homeShortcuts.launch(shortcutItem)
    completionHandler(true)
}
```

### Handle with permission

```swift
homeShortcuts.handleIfNeeded { (item: UIApplicationShortcutItem) in }
```