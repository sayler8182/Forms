//
//  UIViewController.swift
//  FormsUtils
//
//  Created by Konrad on 3/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UIViewController
public extension UIViewController {
    var window: UIWindow? {
        var view: UIView? = self.view
        while view != nil {
            view = view?.superview
            guard let window = view as? UIWindow else { continue }
            return window
        }
        return nil
    }
    
    @discardableResult
    func setupKeyboardWhenTappedAround() -> UITapGestureRecognizer {
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        recognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(recognizer)
        return recognizer
    }
    
    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func disable() {
        if let view = self.tabBarController?.view {
            view.isUserInteractionEnabled = false
        } else if let view = self.navigationController?.view {
            view.isUserInteractionEnabled = false
        } else if let view = self.view {
            view.isUserInteractionEnabled = false
        }
    }
    
    func enable() {
        if let view = self.tabBarController?.view {
            view.isUserInteractionEnabled = true
        } else if let view = self.navigationController?.view {
            view.isUserInteractionEnabled = true
        } else if let view = self.view {
            view.isUserInteractionEnabled = true
        }
    }
}

// MARK: Builder
extension UIViewController {
    @objc
    open func with(backgroundColor: UIColor?) -> Self {
        self.view.backgroundColor = backgroundColor
        return self
    }
    @objc
    open func with(navigationController: UINavigationController) -> UINavigationController {
        navigationController.viewControllers = [self]
        return navigationController
    }
    @objc
    open func with(title: String?) -> Self {
        self.title = title
        return self
    }
}
