//
//  SignInWithGoogleProvider.swift
//  SocialKit
//
//  Created by Konrad on 4/17/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import GoogleSignIn
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
}

// MARK: SignInWithGoogleProvider
public class SignInWithGoogleProvider: NSObject {
    private let context: UIViewController
    
    private var inProgress: Bool = false
    private var onSuccess: ((SignInWithGoogleData) -> Void)? = nil
    private var onError: ((Error) -> Void)? = nil
    private var onCancel: (() -> Void)? = nil
    private var onCompletion: ((SignInWithGoogleData?, Error?) -> Void)? = nil
    
    public init(context: UIViewController) {
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
    
    public func authorization() {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self.context
        GIDSignIn.sharedInstance().signIn()
    }
    
    private func clear() {
        self.inProgress = false
        self.onSuccess = nil
        self.onError = nil
        self.onCompletion = nil
    }
}

// MARK: SignInWithGoogleProvider
extension SignInWithGoogleProvider: GIDSignInDelegate {
    public func sign(_ signIn: GIDSignIn!,
                     didDisconnectWith user: GIDGoogleUser!,
                     withError error: Error!) {
        defer { self.clear() }
        self.onError?(error)
        self.onCompletion?(nil, error)
    }
    
    public func sign(_ signIn: GIDSignIn!,
                     didSignInFor user: GIDGoogleUser!,
                     withError error: Error!) {
        defer { self.clear() }
        if let error: NSError = error as NSError? {
            if error.code == GIDSignInErrorCode.canceled.rawValue {
                self.onCancel?()
                self.onCompletion?(nil, nil)
            } else {
                self.onError?(error)
                self.onCompletion?(nil, error)
            }
        } else if let user: GIDGoogleUser = user {
            let data = SignInWithGoogleData(
                userId: user.userID,
                authenticationToken: user.authentication.idToken,
                email: user.profile.email,
                fullName: user.profile.name,
                givenName: user.profile.givenName,
                familyName: user.profile.familyName
            )
            self.onSuccess?(data)
            self.onCompletion?(data, nil)
        } else {
            let error: SignInWithGoogleError = .unableToLogIn
            self.onError?(error)
            self.onCompletion?(nil, error)
        }
    }
}
