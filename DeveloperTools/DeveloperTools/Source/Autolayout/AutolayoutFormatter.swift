//
//  AutolayoutFormatter.swift
//  DeveloperTools
//
//  Created by Konrad on 4/26/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation
import UIKit

// MARK: AutolayoutFormatter
internal enum AutolayoutFormatter {
    internal static func format(_ context: AutolayoutContext) -> String {
        return """
        
        ⚠️ Catch AutoLayout error and details below
        ===========================================================
        \(Self.buildHeader(context))
        
        \(Self.buildTreeContent(context))
        ===========================================================
        
        """
    }
    
    fileprivate static func buildTreeContent(_ context: AutolayoutContext) -> String {
        var content = ""
        context.tree.enumerated().forEach { (offset, node) in
            if offset == 0 { content += "- " + Self.debugContent(node) + "\n" }
            node.children.forEach { content += Self.space(offset) + "|- " + Self.debugContent($0) + "\n" }
        }
        return content
    }
    
    fileprivate static func buildHeader(_ context: AutolayoutContext) -> String {
        return context.exclusiveConstraints
            .compactMap { constraint in
                let address: String = Self.addres(constraint)
                switch (constraint.firstItem, constraint.secondItem) {
                case (.none, .none):
                    return "NSLayoutConstraint: \(address) Unknown case. \(constraint.displayIdentifier)"
                case (.some(let lhs), .some(let rhs)):
                    let (lAttribute, rAttribute) = (constraint.firstAttribute.displayName, constraint.secondAttribute.displayName)
                    let relation = constraint.relation
                    return "NSLayoutConstraint: \(address) \(Self.itemType(lhs)).\(lAttribute) \(relation.displayName) \(Self.itemType(rhs)).\(rAttribute) \(constraint.displayIdentifier)"
                case (.some(let item), .none):
                    return "NSLayoutConstraint: \(address) \(Self.itemType(item)).\(constraint.firstAttribute.displayName) \(constraint.relation.displayName) \(constraint.constant) \(constraint.displayIdentifier)"
                case (.none, .some(let item)):
                    return "NSLayoutConstraint: \(address) \(Self.itemType(item)).\(constraint.secondAttribute.displayName) \(constraint.relation.displayName) \(constraint.constant) \(constraint.displayIdentifier)"
                }
        }
        .joined(separator: "\n")
    }
    
    fileprivate static func space(_ level: Int) -> String {
        var indent = ""
        stride(from: 0, through: level, by: 1).forEach { _ in indent += " " }
        return indent
    }
    
    fileprivate static func debugContent(_ node: AutolayoutNode) -> String {
        if let identifier: String = (node.responder as? UIView)?.accessibilityIdentifier {
            return "\(identifier):\(Self.addres(node.responder))"
        }
        if let label: String = node.responder.accessibilityLabel {
            return "\(label): \(Self.addres(node.responder))"
        }
        if node.hasAmbiguous {
            let attributes = node.attributes.map { "\($0.displayName)" }.joined(separator: ", ")
            return "❌ \(type(of: node.responder)): \(Self.addres(node.responder)), ambiguous attributes: \(attributes)"
        } else {
            return "\(type(of: node.responder)): \(Self.addres(node.responder))"
        }
    }
    
    fileprivate static func itemType(_ item: AnyObject) -> String {
        guard let guide: UILayoutGuide = item as? UILayoutGuide else { return "\(type(of: item))" }
        guard let view: UIView = guide.view else { return "\(type(of: item))" }
        return "\(type(of: guide)).\(type(of: view))"
    }
    
    fileprivate static func addres(_ object: AnyObject) -> String {
        return String(unsafeBitCast(object, to: Int.self), radix: 16, uppercase: false)
    }
}
