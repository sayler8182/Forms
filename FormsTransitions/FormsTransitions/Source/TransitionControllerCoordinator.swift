//
//  TransitionControllerCoordinator.swift
//  FormsTransitions
//
//  Created by Konrad on 5/6/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TransitionControllerCoordinator
open class TransitionControllerCoordinator: NSObject, UIViewControllerTransitioningDelegate {
    public var interactionController: UIPercentDrivenInteractiveTransition?
    
    public let isDynamic: Bool
    
    public init(isDynamic: Bool = false) {
        self.isDynamic = isDynamic
    }
    
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        return UIPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let presented = presented as? TransitionableController else { return nil }
        return presented.animator(isDynamic: self.isDynamic, isPresenting: true)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let dismissed = dismissed as? TransitionableController else { return nil }
        return dismissed.animator(isDynamic: self.isDynamic, isPresenting: false)
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }
}
