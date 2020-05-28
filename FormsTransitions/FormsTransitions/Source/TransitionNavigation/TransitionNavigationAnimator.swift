//
//  TransitionNavigationAnimator.swift
//  FormsTransitions
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TransitionNavigationAnimator
open class TransitionNavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let isDynamic: Bool
    let operation: UINavigationController.Operation
    
    override public convenience init() {
        self.init(isDynamic: false, operation: .none)
    }
    
    public required init(isDynamic: Bool, operation: UINavigationController.Operation) {
        self.isDynamic = isDynamic
        self.operation = operation
    }
    
    open func with(isDynamic: Bool, operation: UINavigationController.Operation) -> Self {
        return Self(isDynamic: isDynamic, operation: operation)
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
        switch self.operation {
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
            isDynamic: false,
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
