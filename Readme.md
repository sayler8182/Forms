
Forms
========

[![Swift Version](https://img.shields.io/badge/Swift-5.2-F16D39.svg?style=flat)](https://developer.apple.com/swift)

Forms is all in one iOS framework

## Features

- [x] Pure Swift Type Support
- [x] Modular
- [x] [Analytics](./Documentation/Analytics.md) - Application analytics
- [x] [Anchor](./Documentation/Anchor.md) - DSL
- [x] [DeveloperTools](./Documentation/DeveloperTools.md) - Developer Tools
- [x] [Forms](./Documentation/Forms.md) - Forms framework
- [x] [ImagePicker](./Documentation/ImagePicker.md) - Image Picker
- [x] [Injector](./Documentation/Injector.md) - Dependency Injection
- [x] [Logger](./Documentation/Logger.md) - Logger data
- [x] [Mock](./Documentation/Mock.md) - Mocking data
- [x] [Networking](./Documentation/Networking.md) - Network layer
- [x] [Notifications](./Documentation/Notifications.md) - Firebase notifications
- [x] [Permissions](./Documentation/Permissions.md) - Application permissions
- [x] [SideMenu](./Documentation/SideMenu.md) - Side menu
- [x] [SocialKit](./Documentation/SocialKit.md) - Sign in with external services
- [x] [Utils](./Documentation/Utils.md) - Utils and extensions
- [x] [Transition](./Documentation/Transition.md) - UI transitions
- [x] [Validators](./Documentation/Validators.md) - Data validators
- [x] [FormsDemo](./Documentation/FormsDemo.md) - All features demo

## NOTICE
Currently firebase DOSN'T support dynamic framework. You can't use Analytics and Notifications framework together
see https://github.com/firebase/firebase-ios-sdk/blob/master/docs/firebase_in_libraries.md

## Requirements

- iOS 10.0+ 
- Swift 5.2
- Xcode 11.0+

Stable version<br/>
XCode  11.5 (11E608c)

## Installation

Compile from source and copy dynamic framework.
1. Select *Forms* target
2. Build for iPhone and simulator
3. Select *Forms-Universal* target
4. Build
5. Copy generated frameworks

```
Analytics.framework
Anchor.framework
DeveloperTools.framework
Forms.framework
ImagePicker.framework
Injector.framework
Logger.framework
Mock.framework
Networking.framework
Notifications.framework
Permissions.framework
SideMenu.framework
SocialKit.framework
Utils.framework
Transition.framework
Validators.framework
```

## External dependencies

[./Dependencies](./Dependencies) contains external dependencies

```
AppAuth.framework
FBSDKCoreKit.framework
FBSDKLoginKit.framework
FirebaseAnalytics.framework
FirebaseCore.framework
FirebaseCoreDiagnostics.framework
FirebaseInstallations.framework
FirebaseInstanceID.framework
FirebaseMessaging.framework
GTMAppAuth.framework
GTMSessionFetcher.framework
GoogleAppMeasurement.framework
GoogleDataTransport.framework
GoogleDataTransportCCTSupport.framework
GoogleSignIn.framework
GoogleUtilities.framework
PromisesObjC.framework
Protobuf.framework
nanopb.framework
```

To update dependencies You should use 

```
carthage bootstrap
```

and copy downloaded framework to [./Dependencies](./Dependencies) folder

## Contribution Guide or Questions

You can submit issues, ask general questions, or open pull requests.

## Credits

The Forms framework is inspired by:

- *Atchitectures*<br/>
[Clean Swift](https://clean-swift.com/)

- *DeveloperTools*<br/>
[Gedatsu](https://github.com/bannzai/Gedatsu),
[LifetimeTracker](https://github.com/krzysztofzablocki/LifetimeTracker)

- *Injector*<br/>
[Swinject](https://github.com/Swinject/Swinject)


## License

MIT license. See the [LICENSE file](LICENSE) for details.

## TODO:

- [ ] Firebase dynamic frameworks
