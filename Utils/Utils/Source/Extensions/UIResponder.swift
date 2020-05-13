//
//  UIResponder.swift
//  Utils
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UIResponder
public extension UIResponder {
    func becomeFirstResponder(animated: Bool) {
        guard !animated else {
            self.becomeFirstResponder()
            return
        }
        UIView.animate(
            withDuration: 0.0,
            delay: 0.0,
            animations: {
                self.becomeFirstResponder()
        })
    }
    
    func resignFirstResponder(animated: Bool) {
        guard !animated else {
            self.resignFirstResponder()
            return
        }
        UIView.animate(
            withDuration: 0.0,
            delay: 0.0,
            animations: {
                self.resignFirstResponder()
        })
    }
}
