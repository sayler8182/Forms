//
//  UISearchBar.swift
//  Utils
//
//  Created by Konrad on 5/5/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UISearchBar
public extension UISearchBar {
    var activityIndicator: UIActivityIndicatorView? {
        return self.textField.leftView?.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView
    }
    
    var isLoading: Bool {
        get { return self.activityIndicator != nil }
        set { self.setIsLoading(newValue) }
    }
    
    var textField: UITextField! {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            return self.subviews
                .flatMap { $0.subviews }
                .first(where: { $0 is UITextField }) as? UITextField
        }
    }
    
    var placeholderLabel: UILabel! {
        guard let className: AnyClass = NSClassFromString("UISearchBarTextFieldLabel") else { return nil }
        return self.textField.subviews
            .first(where: { $0.isKind(of: className) }) as? UILabel
    }
    
    var placeholderColor: UIColor! {
        get { return self.placeholderLabel.textColor }
        set { self.placeholderLabel.textColor = newValue }
    }
    
    var placeholderFont: UIFont! {
        get { return self.placeholderLabel.font }
        set { self.placeholderLabel.font = newValue }
    }
    
    private func setIsLoading(_ isLoading: Bool) {
        guard isLoading else {
            self.activityIndicator?.removeFromSuperview()
            return
        }
        guard self.activityIndicator == nil else { return }
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()
        self.textField.leftView?.addSubview(activityIndicator)
    }
}
