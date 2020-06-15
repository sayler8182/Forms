//
//  AppDelegate.swift
//  FormsExample
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FirebaseCore
import Forms
import FormsAnalytics
import FormsDemo
import FormsDeveloperTools
import FormsHomeShortcuts
import FormsInjector
import FormsLogger
import FormsNotifications
import FormsPermissions
import FormsSocialKit
import GoogleSignIn
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    @OptionalInjected
    private var homeShortcuts: HomeShortcutsProtocol? // swiftlint:disable:this let_var_whitespace
    
    @OptionalInjected
    private var logger: Logger? // swiftlint:disable:this let_var_whitespace
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // DeveloperTools - Console
        Console.configure()
        
        // Forms
        Forms.configure(Injector.main, [
            DemoAssembly()
        ])
        
        // Firebase
        FirebaseApp.configure()
        
        // GoogleSignIn
        GIDSignIn.sharedInstance().clientID = "513688149579-fhj79mgkeq2rp689dpmfnn7nlkadnf31.apps.googleusercontent.com"
        
        // Analytics
        Analytics.register([
            DemoAnalyticsFirebaseProvider()
        ])
        
        // DeveloperTools
        DeveloperTools.configure(
            features: DemoDeveloperFeatureKeys.allCases,
            featuresFlags: DemoDeveloperFeatureFlagKeys.allCases,
            onSelect: DemoDeveloperToolsManager.onSelect)
        
        // DeveloperTools - LifetimeTracker
        LifetimeTracker.configure()
        
        // HomeShortcuts
        self.homeShortcuts?.add(keys: DemoHomeShortcutsKeys.allCases)
        self.homeShortcuts?.launch(launchOptions)
        
        // Notifications
        Notifications.configure(
            provider: DemoNotificationsFirebaseProvider(),
            onNewToken: { [weak self] (fcm) in
                guard let `self` = self else { return }
                self.logger?.log(.info, "FCM: \(fcm)")
            },
            onWillPresent: { _ in .alert },
            onReceive: { [weak self] (notification) in
                guard let `self` = self else { return }
                self.logger?.log(.info, "Receive: \(notification.request.content.userInfo.prettyPrinted.or(""))")
            },
            onOpen: { [weak self] (response) in
                guard let `self` = self else { return }
                self.logger?.log(.info, "Open: \(response.notification.request.content.userInfo.prettyPrinted.or(""))")
        })
        Notifications.registerRemote()
        
        // SocialKit
        SocialKit.configure()
        
        // Root
        if #available(iOS 13.0, *) {
        } else {
            let window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = DemoRootViewController()
            self.window = window
            window.makeKeyAndVisible()
        }
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Notifications.setAPNSToken(deviceToken)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

// MARK: Shortcut Item
extension AppDelegate {
    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        self.homeShortcuts?.launch(shortcutItem)
        completionHandler(true)
    }
}
