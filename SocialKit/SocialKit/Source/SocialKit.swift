//
//  SocialKit.swift
//  SocialKit
//
//  Created by Konrad on 4/17/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

//#if canImport(GoogleSignIn)
//let SocialKitGoogle: Bool = true
//#endif

#if canImport(FBSDKLoginKit)
#if !canImport(FBSDKCoreKit)
#warning("If you import FBSDKLoginKit you need also import FBSDKCoreKit")
#endif

#endif

#if canImport(GoogleSignIn)
#if !canImport(AppAuth) || !canImport(GTMAppAuth) || !canImport(GTMSessionFetcher)
#warning("If you import GoogleSignIn you need also import AppAuth, GTMAppAuth and GTMSessionFetcher")
#endif
#endif

import Foundation
#if canImport(FBSDKLoginKit)
import FBSDKCoreKit
import FBSDKLoginKit
#endif
#if canImport(GoogleSignIn)
import AppAuth
import GoogleSignIn
import GTMAppAuth
import GTMSessionFetcher
#endif

public enum SocialKit {
    private static var googleClientID: String? = nil
    
    public static func configure(googleClientID: String? = nil) {
        Self.googleClientID = googleClientID
        
        Self.configureApple()
        Self.configureFacebook()
        Self.configureGoogle()
    }
    
    private static func configureApple() { }
    
    private static func configureFacebook() { }
    
    private static func configureGoogle() {
        #if canImport(GoogleSignIn)
        GIDSignIn.sharedInstance().clientID = Self.googleClientID
        #endif
    }
}
