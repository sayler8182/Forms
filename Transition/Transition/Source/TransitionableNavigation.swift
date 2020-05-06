//
//  TransitionableNavigation.swift
//  Transition
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TransitionableNavigation
public protocol TransitionableNavigation: NSObjectProtocol {
    var view: UIView! { get set }
    var animator: TransitionNavigationAnimator { get set }
    var coordinator: TransitionNavigationCoordinator { get set }
    var edgePanGesture: UIScreenEdgePanGestureRecognizer { get set }
    
    @discardableResult
    func popViewController(animated: Bool) -> UIViewController?
    
    func handleTransitionNavigationEdgePan(_ recognizer: UIScreenEdgePanGestureRecognizer)
    
    func animator(for operation: UINavigationController.Operation) -> TransitionNavigationAnimator?
}

public extension TransitionableNavigation {
    func animator(for operation: UINavigationController.Operation) -> TransitionNavigationAnimator? {
        return self.animator.with(operation: operation)
    }
    
    fileprivate func _handleTransitionNavigationEdgePan(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        guard let view: UIView = recognizer.view else {
            self.coordinator.interactionController = nil
            return
        }
        
        let percent: CGFloat = recognizer.translation(in: view).x / view.bounds.size.width
        
        switch recognizer.state {
        case .began:
            self.coordinator.interactionController = UIPercentDrivenInteractiveTransition()
            self.popViewController(animated: true)
        case .changed:
            self.coordinator.interactionController?.update(percent)
        case .ended:
            percent > 0.5
                ? self.coordinator.interactionController?.finish()
                : self.coordinator.interactionController?.cancel()
            self.coordinator.interactionController = nil
        case .cancelled:
            self.coordinator.interactionController?.cancel()
            self.coordinator.interactionController = nil
        default:
            break
        }
    }
}

// MARK: UINavigationController
public extension UINavigationController {
    @objc
    func handleTransitionNavigationEdgePan(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        guard let transitionableNavigation = self as? TransitionableNavigation else { return }
        transitionableNavigation._handleTransitionNavigationEdgePan(recognizer)
    }
}
