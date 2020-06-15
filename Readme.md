
Forms
========

[![Swift Version](https://img.shields.io/badge/Swift-5.2-F16D39.svg?style=flat)](https://developer.apple.com/swift)

Forms is all in one iOS framework

## Features

- [x] Pure Swift Type Support
- [x] Modular
- [x] [Forms](./Documentation/Forms.md) - Forms framework
- [x] [FormsDemo](./Documentation/FormsDemo.md) - All features demo

## Frameworks
- [x] [FormsAnalytics](./Documentation/FormsAnalytics.md) - Application analytics
- [x] [FormsAnchor](./Documentation/FormsAnchor.md) - DSL
- [x] [FormsAppStoreReview](./Documentation/FormsAppStoreReview.md) - AppStore review helper
- [x] [FormsDeveloperTools](./Documentation/FormsDeveloperTools.md) - Developer Tools
- [x] [FormsDevice](./Documentation/FormsDeveloperTools.md) - Device info
- [x] [FormsHomeShortcuts](./Documentation/FormsHomeShortcuts.md) - Home shortcuts
- [x] [FormsInjector](./Documentation/FormsInjector.md) - Dependency Injection
- [x] [FormsLocation](./Documentation/FormsLocation.md) - Location service
- [x] [FormsLogger](./Documentation/FormsLogger.md) - Logger data
- [x] [FormsMock](./Documentation/FormsMock.md) - Mocking data
- [x] [FormsNetworking](./Documentation/FormsNetworking.md) - Network layer
- [x] [FormsNotifications](./Documentation/FormsNotifications.md) - Firebase notifications
- [x] [FormsPermissions](./Documentation/FormsPermissions.md) - Application permissions
- [x] [FormsUtils](./Documentation/FormsUtils.md) - Utils and extensions
- [x] [FormsTransitions](./Documentation/FormsTransitions.md) - UI transitions
- [x] [FormsValidators](./Documentation/FormsValidators.md) - Data validators

## Kits
Kits extend Forms module
- [x] [FormsCardKit](./Documentation/FormsCardKit.md) - Card
- [x] [FormsImagePickerKit](./Documentation/FormsImagePickerKit.md) - Image Picker
- [x] [FormsPagerKit](./Documentation/FormsPagerKit.md) - Pager
- [x] [FormsSideMenuKit](./Documentation/FormsSideMenuKit.md) - Side menu
- [x] [FormsSocialKit](./Documentation/FormsSocialKit.md) - Sign in with external services
- [x] [FormsTabBarKit](./Documentation/FormsSideMenuKit.md) - TabBar
- [x] [FormsToastKit](./Documentation/ToastKit.md) - Toast

## Requirements

- iOS 10.0+ 
- Swift 5.2
- Xcode 11.0+

Stable version<br/>
XCode 11.5 (11E608c)

## Installation

Download project and run *./build.sh* script

```
Forms.framework
FormsAnalytics.framework
FormsAnchor.framework
FormsAppStoreReview.framework
FormsDevice.framework
FormsDeveloperTools.framework
FormsHomeShortcuts.framework
FormsImagePickerKit.framework
FormsInjector.framework
FormsLocation.framework
FormsLogger.framework
FormsMock.framework
FormsNetworking.framework
FormsNotifications.framework
FormsPermissions.framework
FormsPager.framework
FormsSideMenuKit.framework
FormsSocialKit.framework
FormsTabBarKit.framework
FormsToastKit.framework
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

## Demo
FormsDemo contains demo implementations for some providers etc. Just check [FormsDemo/FormsDemo/Source/Implementations](./FormsDemo/FormsDemo/Source/Implementations) folder

## Recommended tools

- [R.swift](https://github.com/mac-cain13/R.swift)

## Contribution Guide or Questions

You can submit issues, ask general questions, or open pull requests.

## Credits

The Forms framework is inspired by:

- *Atchitectures*<br/>
[Clean Swift](https://clean-swift.com/)

- *FormsAnalytics*<br/>
[Umbrella](https://github.com/devxoul/Umbrella),

- *FormsDeveloperTools*<br/>
[Gedatsu](https://github.com/bannzai/Gedatsu),
[LifetimeTracker](https://github.com/krzysztofzablocki/LifetimeTracker)

- *FormsDevice*<br/>
[DeviceKit](https://github.com/devicekit/DeviceKit)

- *FormsInjector*<br/>
[Swinject](https://github.com/Swinject/Swinject)


## License

MIT license. See the [LICENSE file](LICENSE) for details.
