//
//  PermissionLocation.swift
//  Permission
//
//  Created by Konrad on 5/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import CoreLocation
import Foundation

// MARK: PermissionLocationProtocol
public protocol PermissionLocationProtocol: Permissionable {
    func ask(_ completion: @escaping Permission.AskCompletion)
    func askAlways(_ completion: @escaping Permission.AskCompletion)
    func askWhenInUse(_ completion: @escaping Permission.AskCompletion)
    func status(_ completion: @escaping Permission.AskCompletion)
}

// MARK: PermissionLocation
public extension Permission {
    class Location: NSObject, PermissionLocationProtocol, CLLocationManagerDelegate {
        public enum AskType {
            case always
            case whenInUse
        }
        
        fileprivate let locationManager = CLLocationManager()
        fileprivate let defaultAskType: AskType
        fileprivate var askCompletion: Permission.AskCompletion? = nil
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
        
        public func ask(_ completion: @escaping Permission.AskCompletion) {
            switch self.defaultAskType {
            case .always: return self.askAlways(completion)
            case .whenInUse: return self.askWhenInUse(completion)
            }
        }
        
        public func askAlways(_ completion: @escaping Permission.AskCompletion) {
            let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            guard authStatus == .notDetermined || authStatus != .authorizedWhenInUse else {
                return completion(authStatus.permissionStatus)
            }
            self.askCompletion = completion
            self.askAuthStatus = .authorizedAlways
            self.locationManager.requestAlwaysAuthorization()
        }
        
        public func askWhenInUse(_ completion: @escaping Permission.AskCompletion) {
            let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            guard authStatus == .notDetermined else {
                return completion(authStatus.permissionStatus)
            }
            self.askCompletion = completion
            self.askAuthStatus = .authorizedWhenInUse
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        public func status(_ completion: @escaping Permission.AskCompletion) {
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
    
    var permissionStatus: PermissionStatus {
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
