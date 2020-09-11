# FormsUpdates

FormsUpdates is a microservice that checks if there is new app version

## Import

```swift
import FormsUpdates
``` 

## Dependencies

```
FormsUtils.framework
```

## Usage

### Check new version

```swift
let updates = Updates(
    bundle: Bundle.main.bundleId, 
    version: Bundle.main.appVersion)
updates.check { (status) in
    switch (status) {
        case .newVersion(let old, let new): /* */
        case .noChanges: /* */
        case .postponed: /* */
        case .undefined: /* */
    }
}
```

### Mark as checked

```swift
updates.markAsChecked()
```

### Postpone

```swift
updates.postpone()
```

### Cancel

```swift
let task = updates.check { _ in }
task.cancel()
```
