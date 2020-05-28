//
//  TransitionNavigationCoordinator.swift
//  FormsTransitions
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TransitionNavigationCoordinator
open class TransitionNavigationCoordinator: NSObject, UINavigationControllerDelegate {
    public var interactionController: UIPercentDrivenInteractiveTransition?
    public let isDynamic: Bool
    
    public init(isDynamic: Bool = false) {
        self.isDynamic = isDynamic
    }
    
    public func navigationController(_ navigationController: UINavigationController,
                                     animationControllerFor operation: UINavigationController.Operation,
                                     from fromVC: UIViewController,
                                     to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let navigationController = navigationController as? TransitionableNavigation else { return nil }
        guard operation != .none else { return nil }
        return navigationController.animator(isDynamic: self.isDynamic, operation: operation)
    }
    
    public func navigationController(_ navigationController: UINavigationController,
                                     interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }
}
