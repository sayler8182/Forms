//
//  BiometryAuthentication.swift
//  Forms
//
//  Created by Konrad on 9/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import LocalAuthentication

public typealias BiometryOnSuccess = () -> Void
public typealias BiometryOnError = (_ error: Error) -> Void
public typealias BiometryOnCancel = () -> Void
public typealias BiometryOnCompletion = (_ error: Error?) -> Void

// MARK: BiometryError
public enum BiometryError: Error, LocalizedError {
    case evaluate
    case rejected
     
    public var errorDescription: String? {
        switch self {
        case .evaluate: return "Can't evaluate"
        case .rejected: return "Rejected"
        }
    }
}

// MARK: BiometryAuthenticationProtocol
public protocol BiometryAuthenticationProtocol {
    func evaluate(policy: LAPolicy,
                  reason: String,
                  queue: DispatchQueue?,
                  onSuccess: BiometryOnSuccess?,
                  onError: BiometryOnError?,
                  onCancel: BiometryOnCancel?,
                  onCompletion: BiometryOnCompletion?)
}

// MARK: BiometryAuthenticationProtocol
public extension BiometryAuthenticationProtocol {
    func evaluate(policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics,
                  reason: String,
                  queue: DispatchQueue? = .main,
                  onSuccess: BiometryOnSuccess? = nil,
                  onError: BiometryOnError? = nil,
                  onCancel: BiometryOnCancel? = nil) {
        self.evaluate(
            policy: policy,
            reason: reason,
            queue: queue,
            onSuccess: onSuccess,
            onError: onError,
            onCancel: onCancel,
            onCompletion: nil)
    }
    
    func evaluate(policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics,
                  reason: String,
                  queue: DispatchQueue? = .main,
                  onCancel: BiometryOnCancel? = nil,
                  onCompletion: BiometryOnCompletion? = nil) {
        self.evaluate(
            policy: policy,
            reason: reason,
            queue: queue,
            onSuccess: nil,
            onError: nil,
            onCancel: onCancel,
            onCompletion: onCompletion)
    }
}

// MARK: BiometryAuthentication
public class BiometryAuthentication: BiometryAuthenticationProtocol {
    public init() { }
    
    public func evaluate(policy: LAPolicy,
                         reason: String,
                         queue: DispatchQueue? = .main,
                         onSuccess: BiometryOnSuccess?,
                         onError: BiometryOnError?,
                         onCancel: BiometryOnCancel?,
                         onCompletion: BiometryOnCompletion?) { 
        let context: LAContext = LAContext()
        var error: NSError? = nil
        context.canEvaluatePolicy(policy, error: &error)
        if let _error: Error = error {
            onError?(_error)
            onCompletion?(error)
            return
        }
        context.evaluatePolicy(policy, localizedReason: reason) { (success: Bool, error: Error?) in
            if let error: LAError = error as? LAError,
                error.code == LAError.userCancel,
                let onCancel = onCancel {
                DispatchQueue.async(in: queue, execute: onCancel)
                return
            } else if let error: Error = error {
                DispatchQueue.async(in: queue) {
                    onError?(error)
                    onCompletion?(error)
                }
                return
            } else if success {
                DispatchQueue.async(in: queue) {
                    onSuccess?()
                    onCompletion?(nil)
                }
                return
            } else {
                let error: Error = BiometryError.rejected
                DispatchQueue.async(in: queue) {
                    onError?(error)
                    onCompletion?(error)
                }
                return
            } 
        }
    }
}
