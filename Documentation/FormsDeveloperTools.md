# FormsDeveloperTools

FormsDeveloperTools is development helper library.

## Import

```swift
import FormsDeveloperTools
```

## Features

- [x] Pure Swift Type Support
- [x] Console - Console hook and constraints warnings translator
- [x] DeveloperTools - Developer features menu
- [x] LifetimeTracker - Leak tracker

## Console

### Configuration

```swift
// ignores warnings with provided text
Console.configure(ignore: [
    "HTTP load failed, 0/0 bytes"
])
```

### Autolayout error before

```
Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
2020-05-20 15:23:58.720723+0200 FormsExample[25513:6809704] [LayoutConstraints] Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x2825170c0 Forms.Button:0x107fb4260.height >= 44   (active)>",
    "<NSLayoutConstraint:0x282514230 Forms.Button:0x107fb4260.height == 20   (active)>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x2825170c0 Forms.Button:0x107fb4260.height >= 44   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
```

### Autolayout error after

```
⚠️ Catch AutoLayout error and details below
===========================================================
NSLayoutConstraint: 280c37e30 Button.height >= 44.0 
NSLayoutConstraint: 280c236b0 Button.height == 20.0 

- DemoDeveloperToolsAutolayoutViewController: 14fd7bbe0
 |- DemoDeveloperToolsAutolayoutViewController: 14fd7bbe0
  |- UIView: 14fd945c0

===========================================================
```

## DeveloperTools

### Keys definition

```swift
// MARK: DemoDeveloperToolsManager
public enum DemoDeveloperToolsManager {
    public static func onSelect(_ key: DeveloperFeatureKey,
                                _ rootController: UIViewController) {
        guard let controller = Self.controller(for: key) else { return }
        rootController.show(controller, sender: nil)
    }
    
    private static func controller(for key: DeveloperFeatureKey) -> UIViewController? {
        switch key.rawKey {
        case DemoDeveloperFeatureKeys.firstFeature.rawKey:
            return DemoDeveloperToolsMenuFirstFeatureViewController()
        case DemoDeveloperFeatureKeys.secondFeature.rawKey:
            return DemoDeveloperToolsMenuSecondFeatureViewController()
        default:
            return nil
        }
    }
}

// MARK: DemoDeveloperFeatureKeys
public enum DemoDeveloperFeatureKeys: String, CaseIterable, DeveloperFeatureKey {
    case firstFeature
    case secondFeature
    
    public var title: String {
        switch self {
        case .firstFeature: return "First Feature"
        case .secondFeature: return "Second Feature"
        }
    }
}

// MARK: DemoDeveloperFeatureFlagKeys
public enum DemoDeveloperFeatureFlagKeys: String, CaseIterable, DeveloperFeatureFlagKey {
    case firstFeatureFlag
    case secondFeatureFlag
    
    public var title: String {
        switch self {
        case .firstFeatureFlag: return "First Feature Flag"
        case .secondFeatureFlag: return "Second Feature Flag"
        }
    }
}
```

### Configuration

```swift
DeveloperTools.configure(
    features: DemoDeveloperFeatureKeys.allCases,
    featuresFlags: DemoDeveloperFeatureFlagKeys.allCases,
    onSelect: DemoDeveloperToolsManager.onSelect)
```

### Presentation

Shake gesture shows developer menu. On simulator you can use ^⌘Z shortcut.

## LifetimeTracker

### Configuration

```swift
    LifetimeTracker.configure()
```

### Configuration with Manager

```swift
let manager = LifetimeTrackerManager(
    visibility: .alwaysVisible,
    of: LifetimeTrackerDashboardViewController.self)
LifetimeTracker.configure(manager.refresh)
```

### Custom UI

LifetimeTrackerDashboardViewController may be replaced by other LifetimeTrackerView class 

### Item definition

```swift
class LeakItem: LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration()
    }
```

### Tracking definition

```swift
let item: LeakItem = LeakItem()
item.lifetimeTrack()
```

or 

```swift
class LeakItem: LifetimeTrackable {
    ...
    init() {
        self.lifetimeTrack()
    }
    ...
```
