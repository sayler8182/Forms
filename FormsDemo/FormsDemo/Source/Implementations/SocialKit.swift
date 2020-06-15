//
//  SocialKit.swift
//  FormsDemo
//
//  Created by Konrad on 6/13/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import AuthenticationServices
import FBSDKLoginKit
import FormsSocialKit
import GoogleSignIn

// MARK: DemoSignInWithAppleProvider
@available(iOS 13.0, *)
public class DemoSignInWithAppleProvider: SignInWithAppleProviderBase, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    override public func authorization(scopes: [Any]) {
        let authorizationProvider = ASAuthorizationAppleIDProvider()
        let request: ASAuthorizationAppleIDRequest = authorizationProvider.createRequest()
        request.requestedScopes = scopes as? [ASAuthorization.Scope]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    override public func logout() {
        let authorizationProvider = ASAuthorizationAppleIDProvider()
        let request: ASAuthorizationAppleIDRequest = authorizationProvider.createRequest()
        request.requestedOperation = .operationLogout
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.context.view.window ?? ASPresentationAnchor()
    }
    
    public func authorizationController(controller: ASAuthorizationController,
                                        didCompleteWithAuthorization authorization: ASAuthorization) {
        defer { self.clear() }
        switch authorization.credential {
        case let credential as ASAuthorizationAppleIDCredential:
            self.handleASAuthorizationAppleIDCredential(credential)
        default:
            let error: SignInWithAppleError = .unableToHandleCredential
            self.onError?(error)
            self.onCompletion?(nil, error)
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController,
                                        didCompleteWithError error: Error) {
        defer { self.clear() }
        let error = error as NSError
        if error.code == ASAuthorizationError.canceled.rawValue {
            self.onCancel?()
            self.onCompletion?(nil, nil)
        } else {
            self.onError?(error)
            self.onCompletion?(nil, error)
        }
    }
    
    private func handleASAuthorizationAppleIDCredential(_ credential: ASAuthorizationAppleIDCredential) {
        defer { self.clear() }
        guard let jwtData: Data = credential.identityToken,
            let jwt: String = String(data: jwtData, encoding: .utf8) else {
                let error: SignInWithAppleError = .unableToRetrieveJWT
                self.onError?(error)
                self.onCompletion?(nil, error)
                return
        }
        let data = SignInWithAppleData(
            uid: credential.user,
            jwt: jwt,
            email: credential.email,
            nickname: credential.fullName?.nickname)
        self.onSuccess?(data)
        self.onCompletion?(data, nil)
    }
}

// MARK: DemoSignInWithFacebookProvider
public class DemoSignInWithFacebookProvider: SignInWithFacebookProviderBase {
    private lazy var loginManager: LoginManager = LoginManager()
    
    override public func authorization(permissions: [String]) {
        self.loginManager.logIn(permissions: permissions, from: self.context) { [weak self] (result, error) in
            guard let `self` = self else { return }
            self.handleAuthorization(result: result, error: error)
        }
    }
    
    override public func logout() {
        self.loginManager.logOut()
    }
    
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
                    data: result)
                self.onSuccess?(data)
                self.onCompletion?(data, nil)
            } else {
                let error: SignInWithFacebookError = .unableToRetrieveUserInformation
                self.onError?(error)
                self.onCompletion?(nil, error)
            }
        }
    }
}

// MARK: DemoSignInWithGoogleProvider
public class DemoSignInWithGoogleProvider: SignInWithGoogleProviderBase, GIDSignInDelegate {
    override public func authorization() {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self.context
        GIDSignIn.sharedInstance().signIn()
    }
    
    override public func logout() {
        GIDSignIn.sharedInstance()?.signOut()
    }
    
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
                familyName: user.profile.familyName)
            self.onSuccess?(data)
            self.onCompletion?(data, nil)
        } else {
            let error: SignInWithGoogleError = .unableToLogIn
            self.onError?(error)
            self.onCompletion?(nil, error)
        }
    }
}
