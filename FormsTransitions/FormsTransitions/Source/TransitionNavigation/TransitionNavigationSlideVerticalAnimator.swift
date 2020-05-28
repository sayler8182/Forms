//
//  TransitionNavigationSlideVerticalAnimator.swift
//  FormsTransitions
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TransitionNavigationSlideVerticalAnimator
open class TransitionNavigationSlideVerticalAnimator: TransitionNavigationAnimator {
    override open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    override open func viewAnimator(container: UIView,
                                    fromView: UIView,
                                    toView: UIView) -> ViewAnimator {
        return SnapshotViewAnimator(
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
        
        let startFromFrameY = fromView.frame.origin.y
        let startToFrameY = toView.frame.height
        let endFromFrameY = -fromView.frame.height
        let endToFrameY = toView.frame.origin.y
        
        fromView.frame.origin.y = startFromFrameY
        toView.frame.origin.y = startToFrameY
        animator.beginTransition()
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                fromView.frame.origin.y = endFromFrameY
                toView.frame.origin.y = endToFrameY
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
        
        let startFromFrameY = fromView.frame.origin.y
        let startToFrameY = -toView.frame.height
        let endFromFrameY = fromView.frame.height
        let endToFrameY = toView.frame.origin.y
        
        fromView.frame.origin.y = startFromFrameY
        toView.frame.origin.y = startToFrameY
        animator.beginTransition()
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                fromView.frame.origin.y = endFromFrameY
                toView.frame.origin.y = endToFrameY
                animator.updateTransition()
        }, completion: { _ in
            animator.endTransition()
            container.addSubview(toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
