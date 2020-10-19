//
//  SignInWithAppleProvider.swift
//  FormsSocialKit
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: SignInWithAppleError
public enum SignInWithAppleError: Error {
    case unableToRetrieveJWT
    case unableToHandleCredential
}

// MARK: SignInWithApple
public struct SignInWithAppleData {
    public let uid: String
    public let jwt: String
    public let email: String?
    public let nickname: String?
    
    public init(uid: String,
                jwt: String,
                email: String?,
                nickname: String?) {
        self.uid = uid
        self.jwt = jwt
        self.email = email
        self.nickname = nickname
    }
}

// MARK: SignInWithAppleProviderBase
@available(iOS 13.0, *)
open class SignInWithAppleProviderBase: NSObject {
    public weak var context: UIViewController!
    
    public var inProgress: Bool = false
    public var onSuccess: ((SignInWithAppleData) -> Void)? = nil
    public var onError: ((Error) -> Void)? = nil
    public var onCancel: (() -> Void)? = nil
    public var onCompletion: ((SignInWithAppleData?, Error?) -> Void)? = nil
    
    public init(context: UIViewController!) {
        self.context = context
    }
    
    public func authorization(scopes: [Any] = [],
                              onSuccess: @escaping (SignInWithAppleData) -> Void,
                              onError: @escaping (Error) -> Void,
                              onCancel: (() -> Void)? = nil,
                              onCompletion: ((SignInWithAppleData?, Error?) -> Void)? = nil) {
        guard !self.inProgress else { return }
        self.inProgress = true
        self.onSuccess = onSuccess
        self.onError = onError
        self.onCancel = onCancel
        self.onCompletion = onCompletion
        self.authorization(scopes: scopes)
    }
    
    open func authorization(scopes: [Any]) {
        // HOOK
    }
    
    open func logout() {
        // HOOL
    }
    
    public func clear() {
        self.inProgress = false
        self.onSuccess = nil
        self.onError = nil
        self.onCompletion = nil
    }
} 
