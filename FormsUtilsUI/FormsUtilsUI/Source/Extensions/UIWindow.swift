//
//  UIWindow.swift
//  FormsUtils
//
//  Created by Konrad on 6/19/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UIWindow
public extension UIWindow {
    static var new: UIWindow {
        if #available(iOS 13.0, *) {
            let scene: UIWindowScene! = UIApplication.shared.connectedScenes.first as? UIWindowScene
            return UIWindow(windowScene: scene)
        } else {
            return UIWindow(frame: UIScreen.main.bounds)
        }
    } 
    
    func show(_ controller: UIViewController?,
              animated: Bool) {
        self.transition(
            animated,
            duration: 0.3,
            options: [.transitionCrossDissolve],
            animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.rootViewController = controller
                UIView.setAnimationsEnabled(oldState)
        })
    }
}
