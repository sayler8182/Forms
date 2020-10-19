//
//  SignInWithGoogleProvider.swift
//  FormsSocialKit
//
//  Created by Konrad on 4/17/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: SignInWithGoogleError
public enum SignInWithGoogleError: Error {
    case unableToLogIn
}

// MARK: SignInWithGoogle
public struct SignInWithGoogleData {
    public let userId: String
    public let authenticationToken: String
    public let email: String?
    public let fullName: String?
    public let givenName: String?
    public let familyName: String?
    
    public init(userId: String,
                authenticationToken: String,
                email: String?,
                fullName: String?,
                givenName: String?,
                familyName: String?) {
        self.userId = userId
        self.authenticationToken = authenticationToken
        self.email = email
        self.fullName = fullName
        self.givenName = givenName
        self.familyName = familyName
    }
}

// MARK: SignInWithGoogleProviderBase
open class SignInWithGoogleProviderBase: NSObject {
    public weak var context: UIViewController!
    
    public var inProgress: Bool = false
    public var onSuccess: ((SignInWithGoogleData) -> Void)? = nil
    public var onError: ((Error) -> Void)? = nil
    public var onCancel: (() -> Void)? = nil
    public var onCompletion: ((SignInWithGoogleData?, Error?) -> Void)? = nil
    
    public init(context: UIViewController!) {
        self.context = context
    }
    
    public func authorization(onSuccess: @escaping (SignInWithGoogleData) -> Void,
                              onError: @escaping (Error) -> Void,
                              onCancel: (() -> Void)? = nil,
                              onCompletion: ((SignInWithGoogleData?, Error?) -> Void)? = nil) {
        guard !self.inProgress else { return }
        self.inProgress = true
        self.onSuccess = onSuccess
        self.onError = onError
        self.onCancel = onCancel
        self.onCompletion = onCompletion
        self.authorization()
    }
    
    open func authorization() {
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
