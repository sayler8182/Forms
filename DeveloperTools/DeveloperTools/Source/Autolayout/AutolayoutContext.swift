//
//  AutolayoutContext.swift
//  DeveloperTools
//
//  Created by Konrad on 4/26/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation
import UIKit

// MARK: AutolayoutNode
internal class AutolayoutNode {
    internal var responder: UIResponder
    internal var children: [AutolayoutNode] = []
    internal var attributes: Set<NSLayoutConstraint.Attribute> = []
    internal weak var parent: AutolayoutNode?
    
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
    
    fileprivate func addChild(_ node: AutolayoutNode) {
        let hasChild: Bool = self.children.contains { $0.responder === node.responder }
        if hasChild { return }
        self.children.append(node)
    }
    
    fileprivate func inherit(from node: AutolayoutNode) {
        node.attributes.forEach {
            self.attributes.insert($0)
        }
    }
}

// MARK: AutolayoutContext
internal class AutolayoutContext {
    internal let view: UIView
    internal let constraint: NSLayoutConstraint
    internal let exclusiveConstraints: [NSLayoutConstraint]
    internal var tree: [AutolayoutNode] = []
    internal var latestNode: AutolayoutNode?
    
    internal init(view: UIView,
                  constraint: NSLayoutConstraint,
                  exclusiveConstraints: [NSLayoutConstraint]) {
        self.view = view
        self.constraint = constraint
        self.exclusiveConstraints = exclusiveConstraints
    }
    
    internal func buildTree() {
        let ambiguousConstraintNodes = self.exclusiveConstraints
            .flatMap { [AutolayoutNode($0.firstItem, $0.firstAttribute), AutolayoutNode($0.secondItem, $0.secondAttribute)] }
            .compactMap { $0 }
        
        var mergedNodes: [AutolayoutNode] = []
        for node in ambiguousConstraintNodes {
            if let mergedNode = mergedNodes.last(where: { $0.responder === node.responder }) {
                mergedNode.inherit(from: node)
            } else {
                mergedNodes.append(node)
            }
        }
        
        var nodes: [AutolayoutNode] = []
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
    
    private func ancestors(from node: AutolayoutNode,
                           to latestNode: AutolayoutNode?) -> [AutolayoutNode] {
        var current: AutolayoutNode = node
        var ancestors: [AutolayoutNode] = []
        while let next: UIResponder = current.responder.next {
            if next === latestNode?.responder { return ancestors }
            let parent: AutolayoutNode = AutolayoutNode(next)
            ancestors.append(parent)
            
            current.parent = parent
            parent.addChild(parent)
            current = parent
        }
        return ancestors.reversed()
    }
}
