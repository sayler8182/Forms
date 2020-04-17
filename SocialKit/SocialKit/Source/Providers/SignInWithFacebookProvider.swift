//
//  SignInWithFacebookProvider.swift
//  SocialKit
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

#if canImport(FBSDKLoginKit)

import FBSDKCoreKit
import FBSDKLoginKit
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
}

// MARK: SignInWithFacebookProvider
public class SignInWithFacebookProvider: NSObject {
    private weak var context: UIViewController!
    
    private lazy var loginManager: LoginManager = LoginManager()
    private var inProgress: Bool = false
    private var onSuccess: ((SignInWithFacebookData) -> Void)? = nil
    private var onError: ((Error) -> Void)? = nil
    private var onCancel: (() -> Void)? = nil
    private var onCompletion: ((SignInWithFacebookData?, Error?) -> Void)? = nil
    
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
    
    public func authorization(permissions: [String]) {
        self.loginManager.logIn(permissions: permissions, from: self.context) { [weak self] (result, error) in
            guard let `self` = self else { return }
            self.handleAuthorization(result: result, error: error)
        }
    }
    
    private func clear() {
        self.inProgress = false
        self.onSuccess = nil
        self.onError = nil
        self.onCompletion = nil
    }
}

// MARK: SignInWithFacebookProvider
extension SignInWithFacebookProvider {
    private func handleAuthorization(result: LoginManagerLoginResult?,
                                     error: Error?) {
        if let error: NSError = error as NSError? {
            self.onError?(error)
            self.onCompletion?(nil, error)
            self.clear()
        } else if let result: LoginManagerLoginResult = result {
            if result.isCancelled {
                self.onCancel?()
                self.onCompletion?(nil, nil)
                self.clear()
            } else {
                self.fetchUserInformation()
            }
        } else {
            let error: SignInWithFacebookError = .unableToLogIn
            self.onError?(error)
            self.onCompletion?(nil, error)
            self.clear()
        }
    }
    
    private func fetchUserInformation() {
        guard let accessToken: String = AccessToken.current?.tokenString else {
            let error: SignInWithFacebookError = .unableToRetrieveToken
            self.onError?(error)
            self.onCompletion?(nil, error)
            return
        }
        
        GraphRequest(
            graphPath: "/me",
            parameters: ["fields": "id, name, email"]
        ).start { [weak self] (_, result, error) in
            guard let `self` = self else { return }
            defer { self.clear() }
            if let error: Error = error {
                self.onError?(error)
                self.onCompletion?(nil, error)
                return
            } else if let result: Any = result {
                let data = SignInWithFacebookData(
                    accessToken: accessToken,
                    data: result
                )
                self.onSuccess?(data)
                self.onCompletion?(data, nil)
            } else {
                let error: SignInWithFacebookError = .unableToRetrieveUserInformation
                self.onError?(error)
                self.onCompletion?(nil, error)
                return
            }
        }
    }
}

#endif
