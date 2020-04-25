//
//  SceneDelegate.swift
//  FormsExample
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

#if canImport(DeveloperTools)
import DeveloperTools
#endif
import FormsDemo
#if canImport(SocialKit)
import SocialKit
#endif
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        #if canImport(SocialKit)
        SocialKit.configure(
            googleClientID: "513688149579-fhj79mgkeq2rp689dpmfnn7nlkadnf31.apps.googleusercontent.com"
        )
        #endif
        
        #if canImport(DeveloperTools)
        LifetimeTracker.configure(LifetimeTrackerManager(visibility: .alwaysVisible).refresh)
        #endif
        
        let window: UIWindow = UIWindow(windowScene: windowScene)
        window.rootViewController = DemoRootViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
} 
