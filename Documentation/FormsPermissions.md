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

### Camera

```
NSCameraUsageDescription
NSMicrophoneUsageDescription
```

### Location

```
NSLocationWhenInUseUsageDescription
NSLocationAlwaysAndWhenInUseUsageDescription
```

### PhotoLibrary

```
NSPhotoLibraryAddUsageDescription # readonly
NSPhotoLibraryUsageDescription # write/read
```

### Other

```
NFCReaderUsageDescription
NSAppleMusicUsageDescription
NSBluetoothAlwaysUsageDescription
NSBluetoothPeripheralUsageDescription
NSCalendarsUsageDescription
NSContactsUsageDescription
NSFaceIDUsageDescription
NSHealthShareUsageDescription
NSHealthUpdateUsageDescription
NSHomeKitUsageDescription
NSMotionUsageDescription
NSRemindersUsageDescription
NSSiriUsageDescription
NSSpeechRecognitionUsageDescription
NSVideoSubscriberAccountUsageDescription
```

## Usage

### Injections

```swift
// camera
injector.register(PermissionsCameraProtocol.self) { _ in
    Permissions.Camera(defaultMediaType: .video)
}

// location
injector.register(PermissionsLocationProtocol.self) { _ in
    Permissions.Location(defaultAskType: .always)
}

// notifications
injector.register(PermissionsNotificationsProtocol.self) { _ in
    Permissions.Notifications(defaultOptions: [.alert, .badge, .sound])
}

// photo library
injector.register(PermissionsPhotoLibraryProtocol.self) { _ in
    Permissions.PhotoLibrary()
}
```

### Camera

```swift
Permissions.camera.ask { (status: PermissionsStatus) in }
Permissions.camera.ask(.video) { (status: PermissionsStatus) in }
Permissions.camera.status { (status: PermissionsStatus) in }
Permissions.camera.status(.video) { (status: PermissionsStatus) in }
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

### PhotoLibrary

```swift
Permissions.photoLibrary.ask { (status: PermissionsStatus) in }
Permissions.photoLibrary.status { (status: PermissionsStatus) in }
```

### Many permissions

```swift
let permissions: [Permissionable] = [
    Permissions.camera,
    Permissions.location,
    Permissions.notifications,
    Permissions.photoLibrary
]
Permissions.ask(permissions) { (status: Bool) in }
```

### Custom permission

Custom permission class should implement Permissionable protocol.