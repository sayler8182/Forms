//
//  SignInWithFacebookProvider.swift
//  FormsSocialKit
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: SignInWithFacebookError
public enum SignInWithFacebookError: Error {
    case unableToLogIn
    case unableToRetrieveToken
    case unableToRetrieveUserInformation
}

// MARK: SignInWithFacebook
public struct SignInWithFacebookData {
    public let accessToken: String
    public let data: Any
    
    public init(accessToken: String,
                data: Any) {
        self.accessToken = accessToken
        self.data = data
    }
}

// MARK: SignInWithFacebookProviderBase
open class SignInWithFacebookProviderBase: NSObject {
    public weak var context: UIViewController!
    
    public var inProgress: Bool = false
    public var onSuccess: ((SignInWithFacebookData) -> Void)? = nil
    public var onError: ((Error) -> Void)? = nil
    public var onCancel: (() -> Void)? = nil
    public var onCompletion: ((SignInWithFacebookData?, Error?) -> Void)? = nil
    
    public init(context: UIViewController) {
        self.context = context
    }
    
    public func authorization(permissions: [String] = ["email", "public_profile"],
                              onSuccess: @escaping (SignInWithFacebookData) -> Void,
                              onError: @escaping (Error) -> Void,
                              onCancel: (() -> Void)? = nil,
                              onCompletion: ((SignInWithFacebookData?, Error?) -> Void)? = nil) {
        guard !self.inProgress else { return }
        self.inProgress = true
        self.onSuccess = onSuccess
        self.onError = onError
        self.onCancel = onCancel
        self.onCompletion = onCompletion
        self.authorization(permissions: permissions)
    }
    
    open func authorization(permissions: [String]) {
        // HOOK
    }
    
    open func logout() {
        // HOOK
    }
    
    public func clear() {
        self.inProgress = false
        self.onSuccess = nil
        self.onError = nil
        self.onCompletion = nil
    }
}
