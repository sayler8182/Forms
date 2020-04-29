//
//  TransitionSlideHorizontalAnimator.swift
//  Transition
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TransitionSlideHorizontalAnimator
open class TransitionSlideHorizontalAnimator: TransitionAnimator {
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
        
        let startFromFrameX = fromView.frame.origin.x
        let startToFrameX = toView.frame.width
        let endFromFrameX = -fromView.frame.width
        let endToFrameX = toView.frame.origin.x
        
        fromView.frame.origin.x = startFromFrameX
        toView.frame.origin.x = startToFrameX
        animator.beginTransition()
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                fromView.frame.origin.x = endFromFrameX
                toView.frame.origin.x = endToFrameX
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
        
        let startFromFrameX = fromView.frame.origin.x
        let startToFrameX = -toView.frame.width
        let endFromFrameX = fromView.frame.width
        let endToFrameX = toView.frame.origin.x
        
        fromView.frame.origin.x = startFromFrameX
        toView.frame.origin.x = startToFrameX
        animator.beginTransition()
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                fromView.frame.origin.x = endFromFrameX
                toView.frame.origin.x = endToFrameX
                animator.updateTransition()
        }, completion: { _ in
            animator.endTransition()
            container.addSubview(toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
