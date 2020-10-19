# FormsTabBarKit

FormsTabBarKit is tab bar library.

## Import

```swift
import FormsTabBarKit
```

## Dependencies

```
Forms.framework
```

## Usage

TabBarController supports multiple sets

```swift
enum TabBarKeys: String, TabBarKey {
    enum Main: Int, TabBarItemKey,CaseIterable {
        case first
        case second
    }
    enum Other: Int, TabBarItemKey,CaseIterable {
        case first
        case second
        case third
    }

    case main
    case other
    
    var keys: [TabBarItemKey] {
        switch self {
        case .main: return TabBarKeys.Main.allCases
        case .other: return TabBarKeys.Other.allCases
        }
    }
} 
```

```swift
override func setupItems() {
    super.setupItems()
    self.addSet([
            TabBarItem(
                itemKey: TabBarKeys.Main.first,
                viewController: { UIViewController() },
                image: UIImage.from(name: "heart.fill"),
                selectedImage: UIImage.from(name: "heart.fill"),
                title: "First"
            ),
            TabBarItem(
                itemKey: TabBarKeys.Main.second,
                viewController: { return UIViewController() },
                image: UIImage.from(name: "heart"),
                selectedImage: UIImage.from(name: "heart"),
                title: "Second",
                isTranslucent: true
            )
        ], forKey: TabBarKeys.main)
```

Select set and item

```swift
select(TabBarKeys.main, itemKey: TabBarKeys.Main.second)
```

You can show or hide tab bar

```swift
func showTabBar(animated: Bool = true,
                completion: ((Bool) -> Void)? = nil) {
func hideTabBar(animated: Bool = true,
                completion: ((Bool) -> Void)? = nil) {
```