
Forms
========

[![Swift Version](https://img.shields.io/badge/Swift-5.2-F16D39.svg?style=flat)](https://developer.apple.com/swift)

Forms is all in one iOS framework

## Features

- [x] Pure Swift Type Support
- [x] Modular
- [x] [Forms](./Documentation/Forms.md) - Forms framework
- [x] [FormsDemo](./Documentation/FormsDemo.md) - All features demo
- [x] [FormsAnalytics](./Documentation/FormsAnalytics.md) - Application analytics
- [x] [FormsAnchor](./Documentation/FormsAnchor.md) - DSL
- [x] [FormsDeveloperTools](./Documentation/FormsDeveloperTools.md) - Developer Tools
- [x] [FormsImagePicker](./Documentation/FormsImagePicker.md) - Image Picker
- [x] [FormsInjector](./Documentation/FormsInjector.md) - Dependency Injection
- [x] [FormsLogger](./Documentation/FormsLogger.md) - Logger data
- [x] [FormsMock](./Documentation/FormsMock.md) - Mocking data
- [x] [FormsNetworking](./Documentation/FormsNetworking.md) - Network layer
- [x] [FormsNotifications](./Documentation/FormsNotifications.md) - Firebase notifications
- [x] [FormsPermissions](./Documentation/FormsPermissions.md) - Application permissions
- [x] [FormsSideMenu](./Documentation/FormsSideMenu.md) - Side menu
- [x] [FormsSocialKit](./Documentation/FormsSocialKit.md) - Sign in with external services
- [x] [FormsUtils](./Documentation/FormsUtils.md) - Utils and extensions
- [x] [FormsTransitions](./Documentation/FormsTransitions.md) - UI transitions
- [x] [FormsValidators](./Documentation/FormsValidators.md) - Data validators

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
Forms.framework
FormsAnalytics.framework
FormsAnchor.framework
FormsDeveloperTools.framework
FormsImagePicker.framework
FormsInjector.framework
FormsLogger.framework
FormsMock.framework
FormsNetworking.framework
FormsNotifications.framework
FormsPermissions.framework
FormsSideMenu.framework
FormsSocialKit.framework
FormsTransitions.framework
FormsUtils.framework
FormsValidators.framework
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
