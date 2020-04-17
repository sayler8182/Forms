# SocialKit

SocialKit is Social media all in one

## Import

```swift
import SocialKit
```

## Dependencies

```
Forms.framework
```

## External dependencies

```
AppAuth.framework
FBSDKCoreKit.framework
FBSDKLoginKit.framework
GTMAppAuth.framework
GTMSessionFetcher.framework
GoogleSignIn.framework
```

## Features

- [x] Sign in with Apple
- [x] Sign in with Facebook
- [x] Sign in with Google

## Configuration

```Swift
SocialKit.configure(
    googleClientID: "CLIENT_ID"
)
```

## Sign in with Apple

### Required Dependencies

```Swift 
import AuthenticationServices
```

### Usage

```Swift
let provider = SignInWithAppleProvider(context: context)
self.provider.authorization(
    scopes: [.email],
    onSuccess: { (_) in },
    onError: { (_) in },
    onCancel: { (_) in },
    onCompletion: { (_, _) in })
```

## Sign in with Facebook

### Required Dependencies

```Swift 
import FBSDKCoreKit
import FBSDKLoginKit
```

### Usage

```Swift
let provider = SignInWithFacebookProvider(context: context)
self.provider.authorization(
    permissions: ["email"],
    onSuccess: { (_) in },
    onError: { (_) in },
    onCancel: { (_) in },
    onCompletion: { (_, _) in })
```

## Sign in with Google

### Required Dependencies

```Swift 
import AppAuth
import GoogleSignIn
import GTMAppAuth
import GTMSessionFetcher
```

### Usage

```Swift
let provider = SignInWithGoogleProvider(context: context)
self.provider.authorization(
    onSuccess: { (_) in },
    onError: { (_) in },
    onCancel: { (_) in },
    onCompletion: { (_, _) in })
```