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
    var textField: UITextField! {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            return self.subviews.first?.subviews.compactMap {
                $0 as? UITextField
            }.first
        }
    }
}
