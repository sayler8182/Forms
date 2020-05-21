# Permission

Permission microservice

## Import

```swift
import Permission
```

## Dependencies

```
Injector.framework
```

## Plist keys

### Location
```
NSLocationWhenInUseUsageDescription
NSLocationAlwaysAndWhenInUseUsageDescription
```

### Other

```
NFCReaderUsageDescription
NSAppleMusicUsageDescription
NSBluetoothAlwaysUsageDescription
NSBluetoothPeripheralUsageDescription
NSCalendarsUsageDescription
NSCameraUsageDescription
NSContactsUsageDescription
NSFaceIDUsageDescription
NSHealthShareUsageDescription
NSHealthUpdateUsageDescription
NSHomeKitUsageDescription
NSMicrophoneUsageDescription
NSMotionUsageDescription
NSPhotoLibraryAddUsageDescription
NSPhotoLibraryUsageDescription
NSRemindersUsageDescription
NSSiriUsageDescription
NSSpeechRecognitionUsageDescription
NSVideoSubscriberAccountUsageDescription
```

## Usage

### Injections

```swift
// location
injector.register(PermissionLocationProtocol.self) { _ in
    Permission.Location(defaultAskType: .always)
}

// notifications
injector.register(PermissionNotificationsProtocol.self) { _ in
    Permission.Notifications(defaultOptions: [.alert, .badge, .sound])
}
```

### Location

```swift
Permission.location.ask { (status: PermissionStatus) in }
Permission.location.askAlways { (status: PermissionStatus) in }
Permission.location.askWhenInUse { (status: PermissionStatus) in }
Permission.location.status { (status: PermissionStatus) in }
```

### Notifications

```swift
Permission.location.ask { (status: PermissionStatus) in }
Permission.location.ask([.alert, .badge, .sound]) { (status: PermissionStatus) in }
Permission.location.status { (status: PermissionStatus) in }
```

### Many permissions

```swift
let permissions: [Permissionable] = [
    Permission.location,
    Permission.notifications
]
Permission.ask(permissions) { (status: Bool) in }
```

### Custom permission

Custom permission class should implement Permissionable protocol.