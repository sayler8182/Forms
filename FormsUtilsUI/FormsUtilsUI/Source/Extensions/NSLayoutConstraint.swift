//
//  NSLayoutConstraint.swift
//  FormsUtilsUI
//
//  Created by Konrad on 8/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: NSLayoutConstraint.Axis
public extension NSLayoutConstraint.Axis {
    var reversed: NSLayoutConstraint.Axis {
        switch self {
        case .horizontal: return .vertical
        case .vertical: return .horizontal
        @unknown default: return self
        }
    }
}
