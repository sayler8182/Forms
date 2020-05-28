//
//  AppDelegate.swift
//  FormsIntegration
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnalytics
import FormsDeveloperTools
import FormsSocialKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // DeveloperTools - Console
        Console.configure()
        
        // Forms
        Forms.configure()
        
        // Analytics
        Analytics.configure()

        // DeveloperTools
        DeveloperTools.configure()
        
        // DeveloperTools - LifetimeTracker
        LifetimeTracker.configure()
        
        // SocialKit
        SocialKit.configure(
            googleClientID: "513688149579-fhj79mgkeq2rp689dpmfnn7nlkadnf31.apps.googleusercontent.com"
        )
        
        if #available(iOS 13.0, *) {
        } else {
            let window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = FormsIntegrationRootViewController()
            self.window = window
            window.makeKeyAndVisible()
        }
        return true
    }

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
