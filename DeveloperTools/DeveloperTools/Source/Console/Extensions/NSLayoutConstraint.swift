//
//  NSLayoutConstraint.swift
//  DeveloperTools
//
//  Created by Konrad on 4/26/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: NSLayoutConstraint
internal extension NSLayoutConstraint {
    var displayIdentifier: String {
        guard let identifier: String = self.identifier else { return "" }
        return "[\(identifier)]"
    }
}

// MARK: NSLayoutConstraint.Attribute
internal extension NSLayoutConstraint.Attribute {
    var displayName: String {
        switch self {
        case .left: return "left"
        case .right: return "right"
        case .top: return "top"
        case .bottom: return "bottom"
        case .leading: return "leading"
        case .trailing: return "trailing"
        case .width: return "width"
        case .height: return "height"
        case .centerX: return "centerX"
        case .centerY: return "centerY"
        case .lastBaseline: return "lastBaseline"
        case .firstBaseline: return "firstBaseline"
        case .leftMargin: return "leftMargin"
        case .rightMargin: return "rightMargin"
        case .topMargin: return "topMargin"
        case .bottomMargin: return "bottomMargin"
        case .leadingMargin: return "leadingMargin"
        case .trailingMargin: return "trailingMargin"
        case .centerXWithinMargins: return "centerXWithinMargins"
        case .centerYWithinMargins: return "centerYWithinMargins"
        case .notAnAttribute: return "notAnAttribute"
        @unknown default: return ""
        }
    }
}

// MARK: NSLayoutConstraint.Relation
internal extension NSLayoutConstraint.Relation {
    var displayName: String {
        switch self {
        case .equal: return "=="
        case .greaterThanOrEqual: return ">="
        case .lessThanOrEqual: return "<="
        @unknown default: return ""
        }
    }
}
