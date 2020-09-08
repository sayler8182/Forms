//
//  AppDelegate.swift
//  FormsExample
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FBSDKCoreKit
import FirebaseCore
import Forms
import FormsAnalytics
import FormsDatabase
import FormsDatabaseSQLite
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

// MARK: Environment
enum Environment: String, Equatable {
    case prod = "PROD"
    case stage = "STAGE"
    case local = "LOCAL"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private var inactiveCover: InactiveCover = InactiveCover()
    
    @OptionalInjected
    private var database: DatabaseSQLite? // swiftlint:disable:this let_var_whitespace
    
    @OptionalInjected
    private var homeShortcuts: HomeShortcutsProtocol? // swiftlint:disable:this let_var_whitespace
    
    @OptionalInjected
    private var launchOptions: LaunchOptionsProtocol? // swiftlint:disable:this let_var_whitespace
    
    @OptionalInjected
    private var logger: Logger? // swiftlint:disable:this let_var_whitespace
    
    @OptionalInjected
    private var settingsBundle: SettingsBundleProtocol? // swiftlint:disable:this let_var_whitespace
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // DeveloperTools - Console
        Console.configure()
        
        // Forms
        Forms.configure(Injector.main, [
            DemoAssembly()
        ])
        
        // Facebook
        ApplicationDelegate.initializeSDK(launchOptions)
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions)
        
        // Firebase
        FirebaseApp.configure()
        
        // GoogleSignIn
        GIDSignIn.sharedInstance().clientID = "513688149579-fhj79mgkeq2rp689dpmfnn7nlkadnf31.apps.googleusercontent.com"
        
        // Analytics
        Analytics.register([
            DemoAnalyticsCustomProvider(),
            DemoAnalyticsFacebookProvider(),
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
        
        // LaunchOptions
        self.launchOptions?.launch(launchOptions)
        
        // Notifications
        Notifications.configure(
            provider: DemoNotificationsFirebaseProvider(),
            onNewToken: { [weak self] (fcm) in
                guard let `self` = self else { return }
                self.logger?.log(LogType.info, "FCM: \(fcm)")
            },
            onWillPresent: { _ in .alert },
            onReceive: { [weak self] (notification) in
                guard let `self` = self else { return }
                self.logger?.log(LogType.info, "Receive: \(notification.request.content.userInfo.prettyPrinted.or(""))")
            },
            onOpen: { [weak self] (response) in
                guard let `self` = self else { return }
                self.logger?.log(LogType.info, "Open: \(response.notification.request.content.userInfo.prettyPrinted.or(""))")
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
        
        // fonts
        try? Font.register([
            .awesome,
            .ion,
            .material
        ], in: Bundle.main)
        
        // inactive cover
        self.inactiveCover.register()
        
        // settings bundle
        self.settingsBundle?.set(
            value: Bundle.main.appVersion,
            forKey: DemoSettingsBundleKey.appVersion)
        self.settingsBundle?.set(
            value: Bundle.main.buildVersion,
            forKey: DemoSettingsBundleKey.buildVersion)
        self.settingsBundle?.set(
            value: Bundle.main.buildDate?.formatted(format: .full),
            forKey: DemoSettingsBundleKey.buildDate)
        let environment: String = self.settingsBundle?.get(forKey: DemoSettingsBundleKey.environment) ?? "PROD"
        self.logger?.log(LogType.info, "Environment: \(environment)")
        
        // Database
        if self.settingsBundle?.get(forKey: DemoSettingsBundleKey.removeDatabase) ?? false {
            self.settingsBundle?.set(
                value: false,
                forKey: DemoSettingsBundleKey.removeDatabase)
            self.database?.remove()
        }
        self.database?.configure()
        try? database?.connect(
            to: DemoDatabaseSQLiteProvider.self,
            migration: 1)
        try? database?.create([
            DatabaseSQLiteTableModels.self
        ])
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        self.launchOptions?.launch(url)
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
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
