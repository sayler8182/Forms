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
