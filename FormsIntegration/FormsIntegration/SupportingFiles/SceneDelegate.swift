//
//  SceneDelegate.swift
//  FormsIntegration
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//
 
import Forms
import UIKit

// MARK: SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window: UIWindow = UIWindow(windowScene: windowScene)
        Theme.setUserInterfaceStyle(window.traitCollection.userInterfaceStyle)
        window.rootViewController = FormsIntegrationRootViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        guard let window: UIWindow = self.window else { return }
        Theme.setUserInterfaceStyle(window.traitCollection.userInterfaceStyle)
    }
}
