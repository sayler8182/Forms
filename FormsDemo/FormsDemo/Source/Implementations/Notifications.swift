//
//  Notifications.swift
//  FormsDemo
//
//  Created by Konrad on 6/13/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FirebaseCore
import FirebaseMessaging
import FormsNotifications
import FormsPermissions
import UIKit

// MARK: DemoNotificationsFirebaseProvider
public class DemoNotificationsFirebaseProvider: NSObject, NotificationsProvider, MessagingDelegate, UNUserNotificationCenterDelegate {
    public var onNewToken: NotificationsOnNewToken? = nil
    public var onWillPresent: NotificationsOnWillPresent? = nil
    public var onReceive: NotificationsOnReceive? = nil
    public var onOpen: NotificationsOnOpen? = nil
    
    private var handledNotifications: Set<String> = []
    
    public var badge: Int? {
        get { return UIApplication.shared.applicationIconBadgeNumber }
        set { UIApplication.shared.applicationIconBadgeNumber = newValue.or(0) }
    }
    
    override public init() {
        super.init()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
    }
    
    public func setAPNSToken(_ deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.unknown)
    }
    
    public func registerRemote() {
        Permissions.notifications.ask { (status) in
            DispatchQueue.main.async {
                guard status.isAuthorized else { return }
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    public func unregisterRemote() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    public func messaging(_ messaging: Messaging,
                          didReceiveRegistrationToken fcmToken: String) {
        self.onNewToken?(fcmToken)
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        self.onReceiveIfNeeded(notification)
        let options: UNNotificationPresentationOptions = self.onWillPresent?(notification) ?? []
        completionHandler(options)
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        self.onReceiveIfNeeded(response.notification)
        self.onOpen?(response)
        completionHandler()
    }
    
    private func onReceiveIfNeeded(_ notification: UNNotification) {
        if !self.handledNotifications.contains(notification.request.identifier) {
            self.handledNotifications.insert(notification.request.identifier)
            self.onReceive?(notification)
        }
    }
}
