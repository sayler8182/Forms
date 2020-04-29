//
//  SceneDelegate.swift
//  FormsIntegration
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//
 
import Analytics
import DeveloperTools
import SocialKit
import UIKit

// MARK: SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Analytics
        Analytics.configure()
        
        // DeveloperTools
        LifetimeTracker.configure()
        
        // SocialKit
        SocialKit.configure(
            googleClientID: "513688149579-fhj79mgkeq2rp689dpmfnn7nlkadnf31.apps.googleusercontent.com"
        )
        
        let window: UIWindow = UIWindow(windowScene: windowScene)
        window.rootViewController = FormsIntegrationRootViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}
