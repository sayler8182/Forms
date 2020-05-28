# FormsSideMenu

FormsSideMenu is menu library.

## Import

```swift
import FormsSideMenu
```

## Dependencies

```
Forms.framework
```

## Usage

### SideMenu

```swift
class DemoSideMenuController: SideMenuController { 
    private let leftSide UIViewController()
    private let rightSide = UIViewController()
    private let content = UIViewController()
    
    override func setupConfiguration() {
        super.setupConfiguration()
        self.animationTime = 0.3
        self.animationType = .slide
        self.isDismissable = true
        self.leftSideWidth = 300
        self.rightSideWidth = 200
    }
    
    override func setupContent() {
        super.setupContent()
        self.setLeftSide(self.leftSide)
        self.setRightSide(self.rightSide)
        self.setContent(self.content)
    }
}
```

### Open

```swift
self.sideMenuController?.open()
self.sideMenuController?.open(direction: .left)
self.sideMenuController?.open(direction: .right)
```

### Close

```swift
self.sideMenuController?.close()
self.sideMenuController?.close(direction: .left)
self.sideMenuController?.close(direction: .right)
```