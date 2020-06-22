//
//  UINavigationController.swift
//  FormsUtils
//
//  Created by Konrad on 5/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UINavigationController
public extension UINavigationController {
    var rootViewController: UIViewController? {
        return self.viewControllers.first
    }
    
    func rootViewController<T: UIViewController>(of type: T.Type) -> T? {
        return self.rootViewController as? T
    }
    
    func setRoot(_ controller: UIViewController) {
        self.viewControllers = [controller]
    } 
}

// MARK: Builder
public extension UINavigationController {
    func with(controller: UIViewController) -> Self {
        self.viewControllers = [controller]
        return self
    }
    func with(controllers: [UIViewController]) -> Self {
        self.viewControllers = controllers
        return self
    }
    func with(isNavigationBarHidden: Bool) -> UINavigationController {
        self.setNavigationBarHidden(isNavigationBarHidden, animated: false)
        return self
    }
}
