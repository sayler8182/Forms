//
//  ConsoleAutolayoutContext.swift
//  FormsDeveloperTools
//
//  Created by Konrad on 4/26/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation
import UIKit

// MARK: ConsoleAutolayoutNode
internal class ConsoleAutolayoutNode {
    internal var responder: UIResponder
    internal var children: [ConsoleAutolayoutNode] = []
    internal var attributes: Set<NSLayoutConstraint.Attribute> = []
    internal weak var parent: ConsoleAutolayoutNode?
    
    internal var hasAmbiguous: Bool {
        return !self.attributes.isEmpty
    }
    
    fileprivate init(_ responder: UIResponder) {
        self.responder = responder
    }
    
    fileprivate init?(_ anyObject: AnyObject?,
                      _ attribute: NSLayoutConstraint.Attribute) {
        guard let view = anyObject as? View else { return nil }
        guard let responder: UIView = view.view else { return nil }
        self.responder = responder
        self.attributes = [attribute]
    }
    
    fileprivate func addChild(_ node: ConsoleAutolayoutNode) {
        let hasChild: Bool = self.children.contains { $0.responder === node.responder }
        if hasChild { return }
        self.children.append(node)
    }
    
    fileprivate func inherit(from node: ConsoleAutolayoutNode) {
        node.attributes.forEach {
            self.attributes.insert($0)
        }
    }
}

// MARK: ConsoleAutolayoutContext
internal class ConsoleAutolayoutContext {
    internal let view: UIView
    internal let constraint: NSLayoutConstraint
    internal let exclusiveConstraints: [NSLayoutConstraint]
    internal var tree: [ConsoleAutolayoutNode] = []
    internal var latestNode: ConsoleAutolayoutNode?
    
    internal init(view: UIView,
                  constraint: NSLayoutConstraint,
                  exclusiveConstraints: [NSLayoutConstraint]) {
        self.view = view
        self.constraint = constraint
        self.exclusiveConstraints = exclusiveConstraints
    }
    
    internal func buildTree() {
        let ambiguousConstraintNodes = self.exclusiveConstraints
            .flatMap { [ConsoleAutolayoutNode($0.firstItem, $0.firstAttribute), ConsoleAutolayoutNode($0.secondItem, $0.secondAttribute)] }
            .compactMap { $0 }
        
        var mergedNodes: [ConsoleAutolayoutNode] = []
        for node in ambiguousConstraintNodes {
            if let mergedNode = mergedNodes.last(where: { $0.responder === node.responder }) {
                mergedNode.inherit(from: node)
            } else {
                mergedNodes.append(node)
            }
        }
        
        var nodes: [ConsoleAutolayoutNode] = []
        for node in mergedNodes {
            if let sameNode = nodes.first(where: { $0.responder === node.responder }) {
                sameNode.inherit(from: node)
            } else if let ancestor = nodes.first(where: { $0.responder === node.responder.next }) {
                ancestor.addChild(node)
            } else {
                nodes = self.ancestors(from: node, to: self.latestNode) + [node]
                self.latestNode = node
            }
        }
        
        self.tree = nodes
    }
    
    private func ancestors(from node: ConsoleAutolayoutNode,
                           to latestNode: ConsoleAutolayoutNode?) -> [ConsoleAutolayoutNode] {
        var current: ConsoleAutolayoutNode = node
        var ancestors: [ConsoleAutolayoutNode] = []
        while let next: UIResponder = current.responder.next {
            if next === latestNode?.responder { return ancestors }
            let parent: ConsoleAutolayoutNode = ConsoleAutolayoutNode(next)
            ancestors.append(parent)
            
            current.parent = parent
            parent.addChild(parent)
            current = parent
        }
        return ancestors.reversed()
    }
}

// MARK: ConsoleAutolayoutFormatter
internal enum ConsoleAutolayoutFormatter {
    internal static func format(_ context: ConsoleAutolayoutContext) -> String {
        return """
        
        ⚠️ Catch AutoLayout error and details below
        ===========================================================
        \(Self.buildHeader(context))
        
        \(Self.buildTreeContent(context))
        ===========================================================
        
        """
    }
    
    fileprivate static func buildTreeContent(_ context: ConsoleAutolayoutContext) -> String {
        var content = ""
        context.tree.enumerated().forEach { (offset, node) in
            if offset == 0 { content += "- " + Self.debugContent(node) + "\n" }
            node.children.forEach { content += Self.space(offset) + "|- " + Self.debugContent($0) + "\n" }
        }
        return content
    }
    
    fileprivate static func buildHeader(_ context: ConsoleAutolayoutContext) -> String {
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
    
    fileprivate static func debugContent(_ node: ConsoleAutolayoutNode) -> String {
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
