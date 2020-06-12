# FormsNotifications

FormsNotifications handles user notifications.

## Import

```swift
import FormsNotifications
```

## External dependencies

```
FirebaseAnalytics.framework
FirebaseCore.framework
FirebaseCoreDiagnostics.framework
FirebaseInstallations.framework
FirebaseInstanceID.framework
FirebaseMesseging.framework
GoogleAppMeasurement.framework
GoogleDataTransport.framework
GoogleDataTransportCCTSupport.framework
GoogleUtilities.framework
nanopb.framework
PromisesObjC.framework
Protobuf.framework
StoreKit.framework
```

## Integration

Library uses Firebase service. You should create and configure project [here](https://console.firebase.google.com/). In settings add iOS project set *BundleId*, *TeemId* and upload *APNs* .p12 key. Then download *GoogleService-Info.plist* and add to your project. It's also important to add *URL Type* in your Target Info's - *URL Schemas* is your *REVERSED_CLIENT_ID* from *GoogleService-Info.plist*.

In [./Scripts](./Scripts) folder you can find bash script to send push. Just change server key.

## Usage

### Configuration

```swift
Notifications.configure(
    provider: DemoNotificationsFirebaseProvider(),
    onNewToken: { (fcm) in print("\n\(fcm)\n") },
    onWillPresent: { _ in .alert },
    onReceive: { (notification) in print("\(notification.request.content.userInfo)") },
    onOpen: { (response) in print("\(response.notification.request.content.userInfo)") })
```

### Provider

```swift
protocol NotificationsProvider: class {
    var badge: Int? { get set }
    var onNewToken: NotificationsOnNewToken? { get set }
    var onWillPresent: NotificationsOnWillPresent? { get set }
    var onReceive: NotificationsOnReceive? { get set }
    var onOpen: NotificationsOnOpen? { get set }
    
    func setAPNSToken(_ deviceToken: Data)
    func registerRemote()
}
```

### Set APNS token in AppDelegate

```swift
func application(_ application: UIApplication,
                didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Notifications.setAPNSToken(deviceToken)
}
```

### Register / unregister remote

```swift
Notifications.registerRemote()
Notifications.unregisterRemote()
```