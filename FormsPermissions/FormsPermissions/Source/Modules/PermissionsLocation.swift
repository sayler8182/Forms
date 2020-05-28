//
//  PermissionLocation.swift
//  FormsPermissions
//
//  Created by Konrad on 5/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import CoreLocation
import Foundation

// MARK: PermissionsLocationProtocol
public protocol PermissionsLocationProtocol: Permissionable {
    func ask(_ completion: @escaping Permissions.AskCompletion)
    func askAlways(_ completion: @escaping Permissions.AskCompletion)
    func askWhenInUse(_ completion: @escaping Permissions.AskCompletion)
    func status(_ completion: @escaping Permissions.AskCompletion)
}

// MARK: PermissionsLocation
public extension Permissions {
    class Location: NSObject, PermissionsLocationProtocol, CLLocationManagerDelegate {
        public enum AskType {
            case always
            case whenInUse
        }
        
        fileprivate let locationManager = CLLocationManager()
        fileprivate let defaultAskType: AskType
        fileprivate var askCompletion: Permissions.AskCompletion? = nil
        fileprivate var askAuthStatus: CLAuthorizationStatus? = nil
        
        override public init() {
            self.defaultAskType = .whenInUse
            super.init()
            self.locationManager.delegate = self
        }
        
        public init(defaultAskType: AskType) {
            self.defaultAskType = defaultAskType
            super.init()
            self.locationManager.delegate = self
        }
        
        public func ask(_ completion: @escaping Permissions.AskCompletion) {
            switch self.defaultAskType {
            case .always: return self.askAlways(completion)
            case .whenInUse: return self.askWhenInUse(completion)
            }
        }
        
        public func askAlways(_ completion: @escaping Permissions.AskCompletion) {
            let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            guard authStatus == .notDetermined || authStatus != .authorizedWhenInUse else {
                return completion(authStatus.permissionStatus)
            }
            self.askCompletion = completion
            self.askAuthStatus = .authorizedAlways
            self.locationManager.requestAlwaysAuthorization()
        }
        
        public func askWhenInUse(_ completion: @escaping Permissions.AskCompletion) {
            let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            guard authStatus == .notDetermined else {
                return completion(authStatus.permissionStatus)
            }
            self.askCompletion = completion
            self.askAuthStatus = .authorizedWhenInUse
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        public func status(_ completion: @escaping Permissions.AskCompletion) {
            completion(CLLocationManager.authorizationStatus().permissionStatus)
        }
        
        public func locationManager(_ manager: CLLocationManager,
                                    didChangeAuthorization status: CLAuthorizationStatus) {
            guard self.askAuthStatus != nil else { return }
            self.askCompletion?(status.permissionStatus)
            self.askCompletion = nil
            self.askAuthStatus = nil
        }
    }
}

// MARK: CLAuthorizationStatus
public extension CLAuthorizationStatus {
    var isAllowed: Bool {
        return self == CLAuthorizationStatus.authorizedWhenInUse ||
            self == CLAuthorizationStatus.authorizedAlways
    }
    
    var isAllowedAlways: Bool {
        return self == CLAuthorizationStatus.authorizedAlways
    }
    
    var permissionStatus: PermissionsStatus {
        switch self {
        case .notDetermined: return .notDetermined
        case .restricted: return .restricted
        case .denied: return .denied
        case .authorizedAlways: return .authorizedAlways
        case .authorizedWhenInUse: return .authorizedWhenInUse
        @unknown default: return .unknown
        }
    }
}
