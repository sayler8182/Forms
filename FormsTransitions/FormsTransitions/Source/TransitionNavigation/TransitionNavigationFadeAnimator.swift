//
//  TransitionNavigationFadeAnimator.swift
//  FormsTransitions
//
//  Created by Konrad on 10/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TransitionNavigationFadeAnimator
open class TransitionNavigationFadeAnimator: TransitionNavigationAnimator {
    override open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    override open func viewAnimator(container: UIView,
                                    fromView: UIView,
                                    toView: UIView) -> ViewAnimator {
        return SnapshotViewAnimator(
            isDynamic: self.isDynamic,
            container: container,
            fromView: fromView,
            toView: toView)
    }
    
    override open func pushTransition(using transitionContext: UIViewControllerContextTransitioning,
                                      viewAnimator animator: ViewAnimator,
                                      duration: TimeInterval) {
        let container: UIView = animator.container
        let fromView: UIView = animator.fromView
        let toView: UIView = animator.toView
        
        container.addSubview(toView)
        toView.layoutIfNeeded()
        
        let startFromAlpha: CGFloat = fromView.alpha
        let startToAlpha: CGFloat = 0
        let endFromAlpha: CGFloat = 0
        let endToAlpha: CGFloat = toView.alpha
        
        animator.whenDynamic { fromView.alpha = startFromAlpha }
        toView.alpha = startToAlpha
        animator.beginTransition()
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                animator.whenDynamic { fromView.alpha = endFromAlpha }
                toView.alpha = endToAlpha
                animator.updateTransition()
        }, completion: { _ in
            animator.endTransition()
            container.addSubview(toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    override open func popTransition(using transitionContext: UIViewControllerContextTransitioning,
                                     viewAnimator animator: ViewAnimator,
                                     duration: TimeInterval) {
        let container: UIView = animator.container
        let fromView: UIView = animator.fromView
        let toView: UIView = animator.toView
        
        container.insertSubview(toView, belowSubview: fromView)
        toView.layoutIfNeeded()
        
        let startFromAlpha: CGFloat = fromView.alpha
        let startToAlpha: CGFloat = 0
        let endFromAlpha: CGFloat = 0
        let endToAlpha: CGFloat = toView.alpha
        
        fromView.alpha = startFromAlpha
        animator.whenDynamic { toView.alpha = startToAlpha }
        animator.beginTransition()
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: [.calculationModeCubic],
            animations: {
                fromView.alpha = endFromAlpha
                animator.whenDynamic { toView.alpha = endToAlpha }
                animator.updateTransition()
        }, completion: { _ in
            animator.endTransition()
            container.addSubview(toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
