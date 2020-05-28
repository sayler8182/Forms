# FormsPermissions

FormsPermissions microservice

## Import

```swift
import FormsPermission
```

## Dependencies

```
FormsInjector.framework
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
injector.register(PermissionsLocationProtocol.self) { _ in
    Permissions.Location(defaultAskType: .always)
}

// notifications
injector.register(PermissionsNotificationsProtocol.self) { _ in
    Permissions.Notifications(defaultOptions: [.alert, .badge, .sound])
}
```

### Location

```swift
Permissions.location.ask { (status: PermissionsStatus) in }
Permissions.location.askAlways { (status: PermissionsStatus) in }
Permissions.location.askWhenInUse { (status: PermissionsStatus) in }
Permissions.location.status { (status: PermissionsStatus) in }
```

### Notifications

```swift
Permissions.location.ask { (status: PermissionsStatus) in }
Permissions.location.ask([.alert, .badge, .sound]) { (status: PermissionStatus) in }
Permissions.location.status { (status: PermissionsStatus) in }
```

### Many permissions

```swift
let permissions: [Permissionable] = [
    Permissions.location,
    Permissions.notifications
]
Permissions.ask(permissions) { (status: Bool) in }
```

### Custom permission

Custom permission class should implement Permissionable protocol.