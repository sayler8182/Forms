//
//  Notifications.swift
//  Notifications
//
//  Created by Konrad on 5/6/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FirebaseCore
import FirebaseMessaging
import Foundation

// MARK: Notifications
public class Notifications: NSObject {
    public typealias OnUpdate = (_ fcmToken: String) -> Void
    
    fileprivate static var shared = Notifications()
    
    fileprivate var onUpdate: OnUpdate?
    
    public static func configure(_ onUpdate: OnUpdate? = nil) {
        FirebaseApp.configure()
        Self.shared.onUpdate = onUpdate
        Messaging.messaging().delegate = Self.shared
    }
}

// MARK: MessagingDelegate
extension Notifications: MessagingDelegate {
    public func messaging(_ messaging: Messaging,
                          didReceiveRegistrationToken fcmToken: String) {
        self.onUpdate?(fcmToken)
    }
}
