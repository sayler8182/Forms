//
//  TransitionControllerCircleAnimator.swift
//  FormsTransitions
//
//  Created by Konrad on 5/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TransitionControllerCircleAnimator
open class TransitionControllerCircleAnimator: TransitionControllerAnimator {
    private var transitionContext: UIViewControllerContextTransitioning?
    private var animator: ViewAnimator?
    
    private var startFrame: CGRect {
        let screen: CGRect = UIScreen.main.bounds
        let origin: CGPoint = self.sourceView?.center ?? CGPoint(x: screen.width / 2, y: screen.height)
        return CGRect(x: origin.x, y: origin.y, width: 0, height: 0)
    }
    
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
        self.transitionContext = transitionContext
        self.animator = animator
        let container: UIView = animator.container
        let toView: UIView = animator.toView
        
        container.addSubview(toView)
        toView.layoutIfNeeded()
        
        let screen: CGRect = UIScreen.main.bounds
        let radius: CGFloat = ceil(sqrt((screen.width * screen.width) + (screen.height * screen.height)))
        let frame: CGRect = self.startFrame
        let pathStart: UIBezierPath = UIBezierPath(ovalIn: frame)
        let pathEnd: UIBezierPath = UIBezierPath(ovalIn: frame.insetBy(dx: -radius, dy: -radius))

        let layer: CAShapeLayer = CAShapeLayer()
        layer.path = pathStart.cgPath
        toView.layer.mask = layer
        
        animator.beginTransition()
        let animation = CABasicAnimation(keyPath: "path")
        animation.setValue("pushTransition", forKey: "animationKey")
        animation.fromValue = pathStart.cgPath
        animation.toValue = pathEnd.cgPath
        animation.duration = self.transitionDuration(using: self.transitionContext)
        animation.delegate = self
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: "path")
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: animator.updateTransition)
    }
    
    override open func popTransition(using transitionContext: UIViewControllerContextTransitioning,
                                     viewAnimator animator: ViewAnimator,
                                     duration: TimeInterval) {
        self.transitionContext = transitionContext
        self.animator = animator
        let fromView: UIView = animator.fromView
        
        let screen: CGRect = UIScreen.main.bounds
        let radius: CGFloat = ceil(sqrt((screen.width * screen.width) + (screen.height * screen.height)))
        let frame: CGRect = self.startFrame
        let pathStart: UIBezierPath = UIBezierPath(ovalIn: frame.insetBy(dx: -radius, dy: -radius))
        let pathEnd: UIBezierPath = UIBezierPath(ovalIn: frame)
        
        let layer: CAShapeLayer = CAShapeLayer()
        layer.path = pathStart.cgPath
        fromView.layer.mask = layer
        
        animator.beginTransition()
        let animation = CABasicAnimation(keyPath: "path")
        animation.setValue("popTransition", forKey: "animationKey")
        animation.fromValue = pathStart.cgPath
        animation.toValue = pathEnd.cgPath
        animation.duration = self.transitionDuration(using: self.transitionContext)
        animation.delegate = self
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: "path")
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: animator.updateTransition)
    }
}

// MARK: CAAnimationDelegate
extension TransitionControllerCircleAnimator: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let transitionContext: UIViewControllerContextTransitioning = self.transitionContext else { return }
        guard let animator: ViewAnimator = self.animator else { return }
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        animator.fromView.layer.mask = nil
        animator.toView.layer.mask = nil
        animator.endTransition()
        self.transitionContext = nil
        self.animator = nil
    }
}
