//
//  UIView.swift
//  DeveloperTools
//
//  Created by Konrad on 4/26/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import ObjectiveC
import UIKit

// MARK: UIView
internal extension UIView {
    static func swizzle() {
        let from: Method? = class_getInstanceMethod(
            UIView.classForCoder(),
            NSSelectorFromString("engine:willBreakConstraint:dueToMutuallyExclusiveConstraints:"))
        let to: Method? = class_getInstanceMethod(
            UIView.classForCoder(),
            #selector(UIView._autolayout))
        guard let fromMethod = from,
            let toMethod = to else {
                fatalError("Could not swizzle methods")
        }
        method_exchangeImplementations(fromMethod, toMethod)
    }
    
    @objc
    private
    func _autolayout(engine: AnyObject,
                     constraint: NSLayoutConstraint,
                     exclusiveConstraints: [NSLayoutConstraint]) {
        consoleAssert(Thread.isMainThread)
        defer { _autolayout(engine: engine, constraint: constraint, exclusiveConstraints: exclusiveConstraints) }
        guard let isLoggingSuspend: Bool = value(forKey: "_isUnsatisfiableConstraintsLoggingSuspended") as? Bool else { return }
        if isLoggingSuspend { return }
        let context = ConsoleAutolayoutContext(
            view: self,
            constraint: constraint,
            exclusiveConstraints: exclusiveConstraints)
        context.buildTree()
        Console.shared.save {
            Swift.print(ConsoleAutolayoutFormatter.format(context), to: &Console.shared)
        }
    }
}

// MARK: View
internal protocol View {
    var view: UIView? { get }
}

extension UIView: View {
    var view: UIView? {
        return self
    }
}

extension UILayoutGuide: View {
    var view: UIView? {
        return self.owningView
    }
}
