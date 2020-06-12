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
