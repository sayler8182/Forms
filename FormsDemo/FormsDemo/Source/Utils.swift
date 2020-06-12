//
//  Utils.swift
//  FormsDemo
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FirebaseAnalytics
import FirebaseCore
import FirebaseMessaging
import FormsAnalytics
import FormsDeveloperTools
import FormsHomeShortcuts
import FormsInjector
import FormsNotifications
import FormsPermissions
import UIKit

// MARK: AppAssembly
public class DemoAssembly: Assembly {
    public init() { }
    
    public func assemble(injector: Injector) {
        injector.register(HomeShortcutsProtocol.self) { _ in
            HomeShortcuts()
        }
        .inScope(InjectorScope.container)
    }
}

// MARK: DemoAnalyticsFirebaseProvider
public class DemoAnalyticsFirebaseProvider: AnalyticsProvider {
    public let name: String = "Firebase"
    
    public init() { }
    
    public func logEvent(_ event: AnalyticsEvent,
                         _ parameters: [String: Any],
                         _ userProperties: [String: String]) {
        for userProperty in userProperties {
            FirebaseAnalytics.Analytics.setUserProperty(
                userProperty.value,
                forName: userProperty.key)
        }
        FirebaseAnalytics.Analytics.logEvent(
            event.name,
            parameters: parameters)
    }
    
    public func setUserId(_ userId: String?) {
        FirebaseAnalytics.Analytics.setUserID(userId)
    }
}

// MARK: DemoDeveloperToolsManager
public enum DemoDeveloperToolsManager {
    public static func onSelect(_ key: DeveloperFeatureKey,
                                _ rootController: UIViewController) {
        guard let controller = Self.controller(for: key) else { return }
        rootController.show(controller, sender: nil)
    }
    
    private static func controller(for key: DeveloperFeatureKey) -> UIViewController? {
        switch key.rawKey {
        case DemoDeveloperFeatureKeys.firstFeature.rawKey:
            return DemoDeveloperToolsMenuFirstFeatureViewController()
        case DemoDeveloperFeatureKeys.secondFeature.rawKey:
            return DemoDeveloperToolsMenuSecondFeatureViewController()
        default:
            return nil
        }
    }
}

// MARK: DemoDeveloperFeatureKeys
public enum DemoDeveloperFeatureKeys: String, CaseIterable, DeveloperFeatureKey {
    case firstFeature
    case secondFeature
    
    public var title: String {
        switch self {
        case .firstFeature: return "First Feature"
        case .secondFeature: return "Second Feature"
        }
    }
}

// MARK: DemoDeveloperFeatureFlagKeys
public enum DemoDeveloperFeatureFlagKeys: String, CaseIterable, DeveloperFeatureFlagKey {
    case firstFeatureFlag
    case secondFeatureFlag
    
    public var title: String {
        switch self {
        case .firstFeatureFlag: return "First Feature Flag"
        case .secondFeatureFlag: return "Second Feature Flag"
        }
    }
}

// MARK: DemoHomeShortcutsKeys
public enum DemoHomeShortcutsKeys: String, CaseIterable, HomeShortcutsKeysProtocol {
    case option1
    case option2
    
    public var item: HomeShortcutItem {
        let bundleIdentifier: String = Bundle.main.bundleIdentifier ?? ""
        switch self {
        case .option1:
            return HomeShortcutItem(
                bundleIdentifier: bundleIdentifier,
                code: "opt_1",
                title: "Title option 1",
                subtitle: "Subtitle option 1",
                icon: UIApplicationShortcutIcon.from(name: "square.and.arrow.up"),
                userInfo: nil)
        case .option2:
            return HomeShortcutItem(
                bundleIdentifier: bundleIdentifier,
                code: "opt_2",
                title: "Title option 2",
                subtitle: "Subtitle option 2",
                icon: UIApplicationShortcutIcon.from(name: "paperplane.fill"),
                userInfo: nil)
        }
    }
}

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
