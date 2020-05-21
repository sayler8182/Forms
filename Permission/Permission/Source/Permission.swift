//
//  Permission.swift
//  Permission
//
//  Created by Konrad on 5/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation
import Injector

// MARK: PermissionStatus
public enum PermissionStatus: String {
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
    func ask(_ completion: @escaping Permission.AskCompletion)
    func status(_ completion: @escaping Permission.AskCompletion)
}

// MARK: Permission
public enum Permission {
    public typealias AskCompletion = (PermissionStatus) -> Void
    
    public static var location: PermissionLocationProtocol = {
        let location: PermissionLocationProtocol? = Injector.main.resolve()
        return location ?? Permission.Location()
    }()
    
    public static var notifications: PermissionNotificationsProtocol = {
        let notifications: PermissionNotificationsProtocol? = Injector.main.resolve()
        return notifications ?? Permission.Notifications()
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
