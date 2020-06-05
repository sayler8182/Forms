//
//  PermissionsCamera.swift
//  FormsPermissions
//
//  Created by Konrad on 6/3/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import AVFoundation
import Foundation

// MARK: PermissionsCameraProtocol
public protocol PermissionsCameraProtocol: Permissionable {
    func ask(_ completion: @escaping Permissions.AskCompletion)
    func ask(_ mediaType: AVMediaType,
             _ completion: @escaping Permissions.AskCompletion)
    func status(_ completion: @escaping Permissions.AskCompletion)
    func status(_ mediaType: AVMediaType,
                _ completion: @escaping Permissions.AskCompletion)
}

// MARK: PermissionsCamera
public extension Permissions {
    class Camera: NSObject, PermissionsCameraProtocol {
        fileprivate let defaultMediaType: AVMediaType
        
        override public init() {
            self.defaultMediaType = .video
            super.init()
        }
        
        public init(defaultMediaType: AVMediaType) {
            self.defaultMediaType = defaultMediaType
            super.init()
        }
        
        public func ask(_ completion: @escaping Permissions.AskCompletion) {
            return self.ask(self.defaultMediaType, completion)
        }
        
        public func ask(_ mediaType: AVMediaType,
                        _ completion: @escaping Permissions.AskCompletion) {
            AVCaptureDevice.requestAccess(for: mediaType) { (granted) in
                if granted {
                    completion(.authorized)
                } else {
                    completion(.denied)
                }
            }
        }
        
        public func status(_ completion: @escaping Permissions.AskCompletion) {
            self.status(self.defaultMediaType, completion)
        }
        
        public func status(_ mediaType: AVMediaType,
                           _ completion: @escaping Permissions.AskCompletion) {
            completion(AVCaptureDevice.authorizationStatus(for: mediaType).permissionStatus)
        }
    }
}

// MARK: AVAuthorizationStatus
public extension AVAuthorizationStatus {
    var isAllowed: Bool {
        return self == AVAuthorizationStatus.authorized
    }
    
    var permissionStatus: PermissionsStatus {
        switch self {
        case .notDetermined: return .notDetermined
        case .denied: return .denied
        case .authorized: return .authorized
        case .restricted: return .restricted
        @unknown default: return .unknown
        }
    }
}
