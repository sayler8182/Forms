# FormsNotifications

FormsNotifications handles user notifications.
By default integrate Firebase.

## Import

```swift
import FormsNotifications
```

## Dependencies

```
FormsPermissions.framework
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

## NOTICE
Currently firebase DOSN'T support dynamic framework. You can't use *Analytics* and *Notifications* framework together
see https://github.com/firebase/firebase-ios-sdk/blob/master/docs/firebase_in_libraries.md

## Integration

Library uses Firebase service. You should create and configure project [here](https://console.firebase.google.com/). In settings add iOS project set *BundleId*, *TeemId* and upload *APNs* .p12 key. Then download *GoogleService-Info.plist* and add to your project. It's also important to add *URL Type* in your Target Info's - *URL Schemas* is your *REVERSED_CLIENT_ID* from *GoogleService-Info.plist*.

In [./Scripts](./Scripts) folder you can find bash script to send push. Just change server key.

## Usage

### Configuration

```swift
Notifications.configure(
    onNewToken: { fcm in print("\n\(fcm)\n") },
    onWillPresent: { _ in .alert },
    onDidReceive: { response in print("\n\(response.notification.request.content.userInfo)\n") })
```

### Set APNS token in AppDelegate

```swift
func application(_ application: UIApplication,
                didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Notifications.setAPNSToken(deviceToken)
}
```

### Register remote

```swift
Notifications.registerRemote()
```