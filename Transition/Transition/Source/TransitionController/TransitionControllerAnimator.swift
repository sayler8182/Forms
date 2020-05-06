//
//  TransitionControllerAnimator.swift
//  Transition
//
//  Created by Konrad on 5/6/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TransitionControllerAnimator
open class TransitionControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool?
    
    override public convenience init() {
        self.init(isPresenting: nil)
    }
    
    public required init(isPresenting: Bool?) {
        self.isPresenting = isPresenting
    }
    
    open func with(isPresenting: Bool?) -> Self {
        return Self(isPresenting: isPresenting)
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(UINavigationController.hideShowBarDuration)
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container: UIView = transitionContext.containerView
        guard let fromView: UIView = transitionContext.viewController(forKey: .from)?.view else { return }
        guard let toView: UIView = transitionContext.viewController(forKey: .to)?.view else { return }
        let duration: TimeInterval = self.transitionDuration(using: transitionContext)
        let viewAnimator = self.viewAnimator(
            container: container,
            fromView: fromView,
            toView: toView)
        switch self.isPresenting {
        case true:
            self.pushTransition(
                using: transitionContext,
                viewAnimator: viewAnimator,
                duration: duration)
        case false:
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
