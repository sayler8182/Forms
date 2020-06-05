//
//  PermissionsPhotoLibrary.swift
//  FormsPermissions
//
//  Created by Konrad on 6/3/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation
import Photos

// MARK: PermissionsPhotoLibraryProtocol
public protocol PermissionsPhotoLibraryProtocol: Permissionable {
    func ask(_ completion: @escaping Permissions.AskCompletion)
    func status(_ completion: @escaping Permissions.AskCompletion)
}

// MARK: PermissionsPhotoLibrary
public extension Permissions {
    class PhotoLibrary: NSObject, PermissionsPhotoLibraryProtocol {
        public func ask(_ completion: @escaping Permissions.AskCompletion) {
            let authStatus: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            guard authStatus == .notDetermined else {
                return completion(authStatus.permissionStatus)
            }
            PHPhotoLibrary.requestAuthorization { (status) in
                completion(status.permissionStatus)
            }
        }
        
        public func status(_ completion: @escaping Permissions.AskCompletion) {
            completion(PHPhotoLibrary.authorizationStatus().permissionStatus)
        }
    }
}

// MARK: PHAuthorizationStatus
public extension PHAuthorizationStatus {
    var isAllowed: Bool {
        return self == PHAuthorizationStatus.authorized
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
