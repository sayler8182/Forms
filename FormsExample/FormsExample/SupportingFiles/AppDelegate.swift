//
//  AppDelegate.swift
//  FormsExample
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Analytics
import DeveloperTools
import Forms
import FormsDemo
import Injector
// import Notifications
import Permission
import SocialKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Forms
        Forms.initialize(Injector.main)
        
        // Analytics
        Analytics.configure()
        
        // DeveloperTools
        Autolayout.configure()
        DeveloperTools.configure(
            features: DemoDeveloperFeatureKeys.allCases,
            featuresFlags: DemoDeveloperFeatureFlagKeys.allCases,
            onSelect: DemoDeveloperToolsManager.onSelect)
        LifetimeTracker.configure()
        
        // Notifications
        // Notifications.configure(
        //    onNewToken: { fcm in print("\n\(fcm)\n") },
        //    onWillPresent: { _ in .alert },
        //    onDidReceive: { response in print("\n\(response.notification.request.content.userInfo)\n") })
        
        // Permission
        // Permission.notifications.ask { (_) in
        //    Notifications.registerRemote()
        //}
        
        // SocialKit
        SocialKit.configure(
            googleClientID: "513688149579-fhj79mgkeq2rp689dpmfnn7nlkadnf31.apps.googleusercontent.com"
        )
        
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
//         Notifications.setAPNSToken(deviceToken)
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
        print(userInfo)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }
}
