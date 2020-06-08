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

// MARK: Notifications
public class Notifications: NSObject {
    public typealias OnNewToken = (_ fcm: String) -> Void
    public typealias OnWillPresent = (_ notification: UNNotification) -> UNNotificationPresentationOptions
    public typealias OnDidReceive = (_ notification: UNNotificationResponse) -> Void
    
    fileprivate static var shared = Notifications()
    
    fileprivate var onNewToken: OnNewToken?
    fileprivate var onWillPresent: OnWillPresent?
    fileprivate var onDidReceive: OnDidReceive?
    
    public static func configure(onNewToken: OnNewToken? = nil,
                                 onWillPresent: OnWillPresent? = nil,
                                 onDidReceive: OnDidReceive? = nil) {
        Self.shared.onNewToken = onNewToken
        Self.shared.onWillPresent = onWillPresent
        Self.shared.onDidReceive = onDidReceive
        FirebaseApp.configure()
        Messaging.messaging().delegate = Self.shared
    }
    
    public static func setAPNSToken(_ deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.unknown)
    }
    
    public static func registerRemote() {
        Permission.notifications.ask { (status) in
            DispatchQueue.main.async {
                guard status.isAuthorized else { return }
                UNUserNotificationCenter.current().delegate = Self.shared
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
