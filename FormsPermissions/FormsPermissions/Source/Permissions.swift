//
//  Permissions.swift
//  FormsPermissions
//
//  Created by Konrad on 5/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import Foundation

// MARK: PermissionsStatus
public enum PermissionsStatus: String {
    case authorized = "authorized"
    case authorizedAlways = "authorizedAlways"
    case authorizedWhenInUse = "authorizedWhenInUse"
    case denied = "denied"
    case notDetermined = "notDetermined"
    case provisional = "provisional"
    case restricted = "restricted"
    case unknown = "unknown"
    
    var isAuthorized: Bool {
        switch self {
        case .authorized: return true
        case .authorizedAlways: return true
        case .authorizedWhenInUse: return true
        default: return false
        }
    }
}

// MARK: Permissionable
public protocol Permissionable {
    func ask(_ completion: @escaping Permissions.AskCompletion)
    func status(_ completion: @escaping Permissions.AskCompletion)
}

// MARK: Permissions
public enum Permissions {
    public typealias AskCompletion = (PermissionsStatus) -> Void
    
    public static var location: PermissionsLocationProtocol = {
        let location: PermissionsLocationProtocol? = Injector.main.resolve()
        return location ?? Permissions.Location()
    }()
    
    public static var notifications: PermissionsNotificationsProtocol = {
        let notifications: PermissionsNotificationsProtocol? = Injector.main.resolve()
        return notifications ?? Permissions.Notifications()
    }()
    
    public static func ask(_ permissions: [Permissionable],
                           _ completion: @escaping (Bool) -> Void) {
        Self.ask(true, permissions, 0, completion)
    }
    
    private static func ask(_ status: Bool,
                            _ permissions: [Permissionable],
                            _ index: Int,
                            _ completion: @escaping (Bool) -> Void) {
        permissions[index].ask { askStatus in
            let status = status && askStatus.isAuthorized
            let index: Int = index + 1
            if index < permissions.count {
                Self.ask(status, permissions, index, completion)
            } else {
                completion(status)
            }
        }
    }
}
