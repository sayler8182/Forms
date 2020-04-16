//
//  TransitionAnimator.swift
//  Transition
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TransitionAnimator
open class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let operation: UINavigationController.Operation
    
    override public convenience init() {
        self.init(operation: .none)
    }
    
    public required init(operation: UINavigationController.Operation) {
        self.operation = operation
    }
    
    open func with(operation: UINavigationController.Operation) -> Self {
        return Self(operation: operation)
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(UINavigationController.hideShowBarDuration)
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container: UIView = transitionContext.containerView
        guard let fromView: UIView = transitionContext.view(forKey: .from) else { return }
        guard let toView: UIView = transitionContext.view(forKey: .to) else { return }
        let duration: TimeInterval = self.transitionDuration(using: transitionContext)
        let viewAnimator = self.viewAnimator(
            container: container,
            fromView: fromView,
            toView: toView)
        switch operation {
        case .push:
            self.pushTransition(
                using: transitionContext,
                viewAnimator: viewAnimator,
                duration: duration)
        case .pop:
            self.popTransition(
                using: transitionContext,
                viewAnimator: viewAnimator,
                duration: duration)
        default: break
        } 
    }
    
    // HOOKS
    open func viewAnimator(container: UIView,
                           fromView: UIView,
                           toView: UIView) -> ViewAnimator {
        return ViewAnimator(
            container: container,
            fromView: fromView,
            toView: toView)
    }
    
    open func pushTransition(using transitionContext: UIViewControllerContextTransitioning,
                             viewAnimator animator: ViewAnimator,
                             duration: TimeInterval) {
        // HOOK
    }
    
    open func popTransition(using transitionContext: UIViewControllerContextTransitioning,
                            viewAnimator animator: ViewAnimator,
                            duration: TimeInterval) {
        // HOOK
    }
}
