
Forms
========

[![Swift Version](https://img.shields.io/badge/Swift-5.1-F16D39.svg?style=flat)](https://developer.apple.com/swift)

Forms is all in one iOS framework

## Features

- [x] Pure Swift Type Support
- [x] Modular
- [x] [DSL to make Auto Layout](./Documentation/Anchor.md)
- [x] [Dependency Injection](./Documentation/Injector.md)
- [x] [Logger](./Documentation/Logger.md)
- [x] [Networking](./Documentation/Networking.md)
- [x] [SocialKit](./Documentation/SocialKit.md) Sign in with exteranal services
- [x] [Utils and extensions](./Documentation/Utils.md)
- [x] [Validators](./Documentation/Validators.md)
- [x] [Forms](./Documentation/Forms.md)
- [x] [Full demo](./Documentation/FormsDemo.md)

## Requirements

- iOS 13.0+ 
- Swift 5.1
- Xcode 11.0+

## Installation

Compile from source and copy all dynamic framework.

```
Anchor.framework
Forms.framework
Injector.framework
Logger.framework
Networking.framework
SocialKit.framework
Transition.framework
Utils.framework
Validators.framework
```

and possibly

```
FormsDemo.framework
```

and external dependencies

## External dependencies

[./Dependencies](./Dependencies) contains external dependencies

```
AppAuth.framework
FBSDKCoreKit.framework
FBSDKLoginKit.framework
GTMAppAuth.framework
GTMSessionFetcher.framework
GoogleSignIn.framework
```

To update dependencies You should use 

```
carthage bootstrap
```

and copy downloaded framework to ./Dependencies folder

## Contribution Guide or Questions

You can submit issues, ask general questions, or open pull requests.

## Credits

The Forms framework is inspired by:
- [Clean Swift](https://clean-swift.com/)
- [Swinject](https://github.com/Swinject/Swinject)

## License

MIT license. See the [LICENSE file](LICENSE) for details.