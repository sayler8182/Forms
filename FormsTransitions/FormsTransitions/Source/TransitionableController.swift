//
//  TransitionableController.swift
//  FormsTransitions
//
//  Created by Konrad on 5/6/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TransitionableController
public protocol TransitionableController: NSObjectProtocol {
    var view: UIView! { get set }
    var animator: TransitionControllerAnimator { get set }
    var coordinator: TransitionControllerCoordinator { get set }
    var edgePanGesture: UIScreenEdgePanGestureRecognizer { get set }
    
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
    
    func handleTransitionControllerEdgePan(_ recognizer: UIScreenEdgePanGestureRecognizer)
    
    func animator(isDynamic: Bool, isPresenting: Bool) -> TransitionControllerAnimator?
}

public extension TransitionableController {
    func animator(isDynamic: Bool, isPresenting: Bool) -> TransitionControllerAnimator? {
        return self.animator.with(isDynamic: isDynamic, isPresenting: isPresenting)
    }
    
    func _handleTransitionControllerEdgePan(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        guard let view: UIView = recognizer.view else {
            self.coordinator.interactionController = nil
            return
        }
        
        let percent: CGFloat = recognizer.translation(in: view).x / view.bounds.size.width
        
        switch recognizer.state {
        case .began:
            self.coordinator.interactionController = UIPercentDrivenInteractiveTransition()
            self.dismiss(animated: true, completion: nil)
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

// MARK: UIViewController
public extension UIViewController {
    @objc
    func handleTransitionControllerEdgePan(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        guard let transitionableNavigation = self as? TransitionableController else { return }
        transitionableNavigation._handleTransitionControllerEdgePan(recognizer)
    }
}
