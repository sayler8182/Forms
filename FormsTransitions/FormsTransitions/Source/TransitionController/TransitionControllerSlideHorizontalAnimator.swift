//
//  TransitionControllerSlideHorizontalAnimator.swift
//  FormsTransitions
//
//  Created by Konrad on 5/6/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TransitionControllerSlideHorizontalAnimator
open class TransitionControllerSlideHorizontalAnimator: TransitionControllerAnimator {
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
        
        let startFromFrameX = fromView.frame.origin.x
        let startToFrameX = toView.frame.width
        let endFromFrameX = -fromView.frame.width
        let endToFrameX = toView.frame.origin.x
        
        animator.whenDynamic { fromView.frame.origin.x = startFromFrameX }
        toView.frame.origin.x = startToFrameX
        animator.beginTransition()
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                animator.whenDynamic { fromView.frame.origin.x = endFromFrameX }
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
        let fromView: UIView = animator.fromView
        let toView: UIView = animator.toView
        
        let startFromFrameX = fromView.frame.origin.x
        let startToFrameX = -toView.frame.width
        let endFromFrameX = fromView.frame.width
        let endToFrameX = fromView.frame.origin.x
        
        fromView.frame.origin.x = startFromFrameX
        animator.whenDynamic { toView.frame.origin.x = startToFrameX }
        animator.beginTransition()
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                fromView.frame.origin.x = endFromFrameX
                animator.whenDynamic { toView.frame.origin.x = endToFrameX }
                animator.updateTransition()
        }, completion: { _ in
            animator.endTransition()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
