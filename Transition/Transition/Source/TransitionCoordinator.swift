//
//  TransitionCoordinator.swift
//  Transition
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TransitionCoordinator
open class TransitionCoordinator: NSObject, UINavigationControllerDelegate {
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    public func navigationController(_ navigationController: UINavigationController,
                                     animationControllerFor operation: UINavigationController.Operation,
                                     from fromVC: UIViewController,
                                     to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let navigationController = navigationController as? TransitionNavigationController else { return nil }
        guard operation != .none else { return nil }
        return navigationController.animator(for: operation)
    }
    
    public func navigationController(_ navigationController: UINavigationController,
                                     interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }
}
