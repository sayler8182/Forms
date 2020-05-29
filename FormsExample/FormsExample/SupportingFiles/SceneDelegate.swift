//
//  SceneDelegate.swift
//  FormsExample
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsDemo
import UIKit

// MARK: SceneDelegate
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window: UIWindow = UIWindow(windowScene: windowScene)
        Theme.setUserInterfaceStyle(window.traitCollection.userInterfaceStyle)
        window.rootViewController = DemoRootViewController()
        self.window = window
        window.makeKeyAndVisible() 
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        guard let window: UIWindow = self.window else { return }
        Theme.setUserInterfaceStyle(window.traitCollection.userInterfaceStyle)
    }
    
    func windowScene(_ windowScene: UIWindowScene,
                     didUpdate previousCoordinateSpace: UICoordinateSpace,
                     interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation,
                     traitCollection previousTraitCollection: UITraitCollection) {
        Theme.setUserInterfaceStyle(windowScene.traitCollection.userInterfaceStyle)
    }
}
