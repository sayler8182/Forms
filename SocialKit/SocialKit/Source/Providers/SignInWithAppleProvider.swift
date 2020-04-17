//
//  SignInWithAppleProvider.swift
//  SocialKit
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import AuthenticationServices

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
    public let fullName: PersonNameComponents?
}

// MARK: SignInWithAppleProvider
public class SignInWithAppleProvider: NSObject {
    private weak var context: UIViewController!
    
    private var inProgress: Bool = false
    
    private var onSuccess: ((SignInWithAppleData) -> Void)? = nil
    private var onError: ((Error) -> Void)? = nil
    private var onCancel: (() -> Void)? = nil
    private var onCompletion: ((SignInWithAppleData?, Error?) -> Void)? = nil
    
    public init(context: UIViewController) {
        self.context = context
    }
    
    public func authorization(scopes: [ASAuthorization.Scope]? = [.email],
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
    
    private func authorization(scopes: [ASAuthorization.Scope]?) {
        let authorizationProvider = ASAuthorizationAppleIDProvider()
        let request: ASAuthorizationAppleIDRequest = authorizationProvider.createRequest()
        request.requestedScopes = scopes
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func clear() {
        self.inProgress = false
        self.onSuccess = nil
        self.onError = nil
        self.onCompletion = nil
    }
}

// MARK: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding
extension SignInWithAppleProvider: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
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
            fullName: credential.fullName
        )
        self.onSuccess?(data)
        self.onCompletion?(data, nil)
    }
}
