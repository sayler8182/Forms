# FormsDemo

FormsDemo is all features demo.

## Import

```swift
import FormsDemo
```

## Dependencies

```
Forms.framework
FormsAnalytics.framework
FormsDeveloperTools.framework
FormsImagePicker.framework
FormsMock.framework
FormsNetworking.framework
FormsPermissions.framework
FormsSideMenu.framework
FormsSocialKit.framework
FormsTransition.framework
```

## Usage

### Forms Demo

```swift
let window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
window.rootViewController = DemoRootViewController()
window.makeKeyAndVisible()
```

### Forms Demo with custom components

Create own Demo structure

```swift
protocol DemoRowType {
    var rawValue: String { get }
}

protocol DemoRow {
    var type: DemoRowType { get }
    var title: String { get }
    var subtitle: String? { get }
    var sections: [DemoSection] { get }
    var shouldPresent: Bool { get }
}

protocol DemoSection {
    var title: String? { get }
    var rows: [DemoRow] { get }
}
```

Initialization

```swift
let sections: [DemoSection] = /* custom sections */
DemoRootViewController(sections, getRowController) 

func getRowController(row: DemoRow) -> UIViewController? {
    // switch your row.type
}
```

### Architectures - CleanSwift

There is *CleanSwift.xctemplate* in [./FormsExample/Resources/Templates](./FormsExample/Resources/Templates) folder. You can copy it to 

```
~/Library/Developer/Xcode/Template/Custom
```