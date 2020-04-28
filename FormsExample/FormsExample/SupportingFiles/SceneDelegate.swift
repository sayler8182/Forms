//
//  SceneDelegate.swift
//  FormsExample
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Analytics
import DeveloperTools
import FormsDemo
import SocialKit
import UIKit

// MARK: SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        Analytics.configure()
        DeveloperTools.configure(
            features: DemoDeveloperFeatureKeys.allCases,
            featuresFlags: DemoDeveloperFeatureFlagKeys.allCases,
            onSelect: DemoDeveloperToolsManager.onSelect)
        LifetimeTracker.configure()
        SocialKit.configure(
            googleClientID: "513688149579-fhj79mgkeq2rp689dpmfnn7nlkadnf31.apps.googleusercontent.com"
        )
        
        let window: UIWindow = UIWindow(windowScene: windowScene)
        window.rootViewController = DemoRootViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}
