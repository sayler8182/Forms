# SocialKit

SocialKit is Social media all in one.

## Import

```swift
import SocialKit
```

## Dependencies

```
Forms.framework
```

## External dependencies

Sign in with Facebook
```
FBSDKCoreKit.framework
FBSDKLoginKit.framework
```

Sign in with Google

```
AppAuth.framework
GTMAppAuth.framework
GTMSessionFetcher.framework
GoogleSignIn.framework
```

## Features

- [x] Sign in with Apple
- [x] Sign in with Facebook
- [x] Sign in with Google

## NOTICE
Currently firebase DOSN'T support dynamic framework. There could be a problem with *Sign in with Google* when you use *Analytics* or *Notifications* framework 
see https://github.com/firebase/firebase-ios-sdk/blob/master/docs/firebase_in_libraries.md

## Usage

## Configuration

```swift
SocialKit.configure(
    googleClientID: "CLIENT_ID"
)
```

## Usage - Sign in with Apple - iOS 13+ only

### Required Dependencies

```swift 
import AuthenticationServices
```

### Authorization

```swift
let provider = SignInWithAppleProvider(context: context)
self.provider.authorization(
    scopes: [.email],
    onSuccess: { (_) in },
    onError: { (_) in },
    onCancel: { (_) in },
    onCompletion: { (_, _) in })
```

### Component

```swift
let signInWithApple = Components.social.signInWithApple()
```

## Usage - Sign in with Facebook

### Integration

Library uses FBSDK service. You should create and configure project [here](https://developers.facebook.com/). Then configure Facebook login for your project. It's also important to add *URL Type* in your Target Info's - *URL Schemas* is your fb*APP_ID* from panel.

You need to add additional keys in your Info.plist
```
FacebookAppID -> *APP_ID*
FacebookDisplayName -> *APP_NAME*
LSApplicationQueriesSchemes -> ["fbapi", "fb-messenger-api", "fbauth2", "fbshareextension"]
```

### Required Dependencies

```swift 
import FBSDKCoreKit
import FBSDKLoginKit
```

### Authorization

```swift
let provider = SignInWithFacebookProvider(context: context)
self.provider.authorization(
    permissions: ["email"],
    onSuccess: { (_) in },
    onError: { (_) in },
    onCancel: { (_) in },
    onCompletion: { (_, _) in })
```

### Component

```swift
let signInWithFacebook = Components.social.signInWithFacebook()
```

## Usage - Sign in with Google 

### Required Dependencies

```swift 
import AppAuth
import GoogleSignIn
import GTMAppAuth
import GTMSessionFetcher
```

### Integration

Library uses Firebase service. You should create and configure project [here](https://console.firebase.google.com/). Then download *GoogleService-Info.plist* and add to your project. It's also important to add *URL Type* in your Target Info's - *URL Schemas* is your *REVERSED_CLIENT_ID* from *GoogleService-Info.plist*.

### Authorization

```swift
let provider = SignInWithGoogleProvider(context: context)
self.provider.authorization(
    onSuccess: { (_) in },
    onError: { (_) in },
    onCancel: { (_) in },
    onCompletion: { (_, _) in })
```

### Component

```swift
let signInWithGoogle = Components.social.signInWithGoogle()
```