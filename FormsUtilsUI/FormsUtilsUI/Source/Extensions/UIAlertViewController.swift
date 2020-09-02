//
//  UIAlertViewController.swift
//  FormsUtils
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UIAlertControllerSource
public protocol UIAlertControllerSource {
    func setSource(to controller: UIPopoverPresentationController?)
}

// MARK: UIAlertController
public extension UIAlertController {
    struct SourceView {
        let view: UIView
        let rect: CGRect? = nil
    }
}

// MARK: UIAlertController
public extension UIAlertController {
    convenience init(title: String? = nil,
                     message: String? = nil,
                     preferredStyle: UIAlertController.Style = .alert,
                     source: SourceView? = nil) {
        self.init(
            title: title,
            message: message,
            preferredStyle: preferredStyle)
        source?.setSource(to: self.popoverPresentationController)
    }
    
    func present(on controller: UIViewController,
                 animated animation: Bool = true,
                 completion: (() -> Void)? = nil) {
        controller.present(self, animated: animation, completion: completion)
    }
    
    func addAction(title: String?,
                   style: UIAlertAction.Style,
                   handler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(action)
    }
}

// MARK: Source
extension UIAlertController.SourceView: UIAlertControllerSource {
    public func setSource(to controller: UIPopoverPresentationController?) {
        guard let controller: UIPopoverPresentationController = controller else { return }
        controller.sourceView = self.view
        if let rect: CGRect = self.rect {
            controller.sourceRect = rect
        } else {
            let frame: CGRect = self.view.frame
            controller.sourceRect = CGRect(
                x: frame.size.width / 2,
                y: frame.size.height / 2,
                width: 0,
                height: 0)
        }
    }
}

// MARK: Builder
public extension UIAlertController {
    func with(action: String?,
              style: UIAlertAction.Style = .default,
              handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        self.addAction(title: action, style: style, handler: handler)
        return self
    }
    func with(message: String?) -> Self {
        self.message = message
        return self
    } 
    func with(title: String) -> Self {
        self.title = title
        return self
    }
}
