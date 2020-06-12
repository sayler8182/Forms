//
//  Notifications.swift
//  FormsNotifications
//
//  Created by Konrad on 5/6/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit
import UserNotifications

public typealias NotificationsOnNewToken = (_ fcm: String) -> Void
public typealias NotificationsOnWillPresent = (_ notification: UNNotification) -> UNNotificationPresentationOptions
public typealias NotificationsOnReceive = (_ notification: UNNotification) -> Void
public typealias NotificationsOnOpen = (_ notification: UNNotificationResponse) -> Void

// MARK: NotificationsProvider
public protocol NotificationsProvider: class {
    var badge: Int? { get set }
    var onNewToken: NotificationsOnNewToken? { get set }
    var onWillPresent: NotificationsOnWillPresent? { get set }
    var onReceive: NotificationsOnReceive? { get set }
    var onOpen: NotificationsOnOpen? { get set }
    
    func setAPNSToken(_ deviceToken: Data)
    func registerRemote()
    func unregisterRemote()
}

// MARK: Notifications
public class Notifications: NSObject {
    private static var provider: NotificationsProvider?
    
    public static var badge: Int? {
        get { return Self.provider?.badge }
        set { Self.provider?.badge = newValue }
    }
    
    public static func configure(provider: NotificationsProvider,
                                 onNewToken: NotificationsOnNewToken? = nil,
                                 onWillPresent: NotificationsOnWillPresent? = nil,
                                 onReceive: NotificationsOnReceive? = nil,
                                 onOpen: NotificationsOnOpen? = nil) {
        Self.provider = provider
        provider.onNewToken = onNewToken
        provider.onWillPresent = onWillPresent
        provider.onReceive = onReceive
        provider.onOpen = onOpen
    }
    
    public static func setAPNSToken(_ deviceToken: Data) {
        Self.provider?.setAPNSToken(deviceToken)
    }
    
    public static func registerRemote() {
        Self.provider?.registerRemote()
    }
    
    public static func unregisterRemote() {
        Self.provider?.unregisterRemote()
    }
}
