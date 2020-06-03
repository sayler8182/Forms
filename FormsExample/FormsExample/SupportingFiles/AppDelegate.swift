//
//  AppDelegate.swift
//  FormsExample
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnalytics
import FormsDemo
import FormsDeveloperTools
import FormsInjector
import FormsLogger
// import Notifications
import FormsPermissions
import FormsSocialKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    @Injected
    private var logger: LoggerProtocol? // swiftlint:disable:this let_var_whitespace
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // DeveloperTools - Console
        Console.configure()
        
        // Forms
        Forms.configure()
        
        // Analytics
        Analytics.configure()
        
        // DeveloperTools
        DeveloperTools.configure(
            features: DemoDeveloperFeatureKeys.allCases,
            featuresFlags: DemoDeveloperFeatureFlagKeys.allCases,
            onSelect: DemoDeveloperToolsManager.onSelect)
        
        // DeveloperTools - LifetimeTracker
        LifetimeTracker.configure()
        
        // Notifications
        // Notifications.configure(
        //    onNewToken: { fcm in logger?.log(.info, "\n\(fcm)\n") },
        //    onWillPresent: { _ in .alert },
        //    onDidReceive: { response in logger?.log(.info, "\n\(response.notification.request.content.userInfo)\n") })
        
        // Permission
        // Permission.notifications.ask { (_) in
        //    Notifications.registerRemote()
        // }
        
        // SocialKit
        SocialKit.configure(
            googleClientID: "513688149579-fhj79mgkeq2rp689dpmfnn7nlkadnf31.apps.googleusercontent.com")
        
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
         // Notifications.setAPNSToken(deviceToken)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.logger?.log(.info, userInfo)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        self.logger?.log(.info, userInfo)
    }
}
