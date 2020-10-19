//
//  PermissionNotifications.swift
//  FormsPermissions
//
//  Created by Konrad on 5/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation
import UserNotifications

// MARK: PermissionsNotificationsProtocol
public protocol PermissionsNotificationsProtocol: Permissionable {
    func ask(_ completion: @escaping Permissions.AskCompletion)
    func ask(_ options: UNAuthorizationOptions,
             _ completion: @escaping Permissions.AskCompletion)
    func status(_ completion: @escaping Permissions.AskCompletion)
}

// MARK: PermissionsNotifications
public extension Permissions {
    class Notifications: NSObject, PermissionsNotificationsProtocol {
        fileprivate let notificationCenter = UNUserNotificationCenter.current()
        fileprivate let defaultOptions: UNAuthorizationOptions
        
        override public init() {
            self.defaultOptions = [.alert, .badge, .sound]
            super.init()
        }
        
        public init(defaultOptions: UNAuthorizationOptions) {
            self.defaultOptions = defaultOptions
            super.init()
        }
        
        public func ask(_ completion: @escaping Permissions.AskCompletion) {
            return self.ask(self.defaultOptions, completion)
        }
        
        public func ask(_ options: UNAuthorizationOptions,
                        _ completion: @escaping Permissions.AskCompletion) {
            self.notificationCenter.requestAuthorization(options: options) { [weak self] (_, _) in
                guard let `self` = self else { return }
                self.notificationCenter.getNotificationSettings { (settings) in
                    completion(settings.authorizationStatus.permissionStatus)
                }
            }
        }
        
        public func status(_ completion: @escaping Permissions.AskCompletion) {
            self.notificationCenter.getNotificationSettings { (settings) in                    completion(settings.authorizationStatus.permissionStatus)
            }
        }
    }
}

// MARK: UNAuthorizationStatus
public extension UNAuthorizationStatus {
    var isAllowed: Bool {
        return self == UNAuthorizationStatus.authorized
    }
    
    var permissionStatus: PermissionsStatus {
        switch self {
        case .notDetermined: return .notDetermined
        case .denied: return .denied
        case .authorized: return .authorized
        case .provisional: return .provisional
        case .ephemeral: return .ephemeral
        @unknown default: return .unknown
        }
    }
}
