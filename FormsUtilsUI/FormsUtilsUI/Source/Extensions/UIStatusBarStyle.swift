//
//  UIStatusBarStyle.swift
//  FormsUtils
//
//  Created by Konrad on 5/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UIStatusBarStyle
public extension UIStatusBarStyle {
    var inversed: UIStatusBarStyle {
        switch self {
        case .darkContent:
            return .lightContent
        case .lightContent:
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        case .default:
            return .lightContent
        @unknown default:
            return self
        }
    }
}
