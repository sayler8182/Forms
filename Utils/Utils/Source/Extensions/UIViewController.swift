//
//  UIViewController.swift
//  Utils
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
public extension UIViewController {
    func with(backgroundColor: UIColor?) -> Self {
        self.view.backgroundColor = backgroundColor
        return self
    }
    func with(navigationController: UINavigationController) -> UINavigationController {
        navigationController.viewControllers = [self]
        return navigationController
    }
    func with(title: String?) -> Self {
        self.title = title
        return self
    }
}
