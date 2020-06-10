//
//  Notifications.swift
//  FormsNotifications
//
//  Created by Konrad on 5/6/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FirebaseCore
import FirebaseMessaging
import FormsPermission
import UIKit
import UserNotifications

// MARK: NotificationsProtocol
public protocol NotificationsProtocol {
    var badge: Int { get set }
    
    func configure(onNewToken: OnNewToken? = nil,
                   onWillPresent: OnWillPresent? = nil,
                   onDidReceive: OnDidReceive? = nil)
    func setAPNSToken(_ deviceToken: Data)
    func registerRemote()
}

// MARK: Notifications
public class Notifications: NSObject {
    public typealias OnNewToken = (_ fcm: String) -> Void
    public typealias OnWillPresent = (_ notification: UNNotification) -> UNNotificationPresentationOptions
    public typealias OnDidReceive = (_ notification: UNNotificationResponse) -> Void
    
    fileprivate var onNewToken: OnNewToken?
    fileprivate var onWillPresent: OnWillPresent?
    fileprivate var onDidReceive: OnDidReceive?
    
    public var badge: Int {
        get { return UIApplication.shared.applicationIconBadgeNumber }
        set { UIApplication.shared.applicationIconBadgeNumber = newValue }
    }
    
    public init() { }
    
    public func configure(onNewToken: OnNewToken? = nil,
                          onWillPresent: OnWillPresent? = nil,
                          onDidReceive: OnDidReceive? = nil) {
        self.onNewToken = onNewToken
        self.onWillPresent = onWillPresent
        self.onDidReceive = onDidReceive
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
    
    public func setAPNSToken(_ deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.unknown)
    }
    
    public func registerRemote() {
        Permission.notifications.ask { (status) in
            DispatchQueue.main.async {
                guard status.isAuthorized else { return }
                UNUserNotificationCenter.current().delegate = self
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

// MARK: MessagingDelegate
extension Notifications: MessagingDelegate {
    public func messaging(_ messaging: Messaging,
                          didReceiveRegistrationToken fcmToken: String) {
        self.onNewToken?(fcmToken)
    }
}

// MARK: UNUserNotificationCenterDelegate
extension Notifications: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let options: UNNotificationPresentationOptions = self.onWillPresent?(notification) ?? UNNotificationPresentationOptions.alert
        completionHandler(options)
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        self.onDidReceive?(response)
        completionHandler()
    }
}
