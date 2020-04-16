//
//  TransitionNavigationController.swift
//  Transition
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TransitionNavigationController
open class TransitionNavigationController: UINavigationController {
    public var animator: TransitionAnimator? {
        didSet { self.delegate = self.coordinator }
    }
    private let coordinator: TransitionCoordinator = TransitionCoordinator()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    open func setupView() {
        self.setupConfiguration()
        self.setupContent()
        self.setupActions()
    }
    
    open func setupConfiguration() {
        // HOOK
    }
    
    open func setupContent() {
        self.view.backgroundColor = UIColor.white
        // HOOK
    }
    
    open func setupActions() {
        let swipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGestureRecognizer.edges = .left
        self.view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    public func animator(for operation: UINavigationController.Operation) -> TransitionAnimator? {
        return self.animator?.with(operation: operation)
    }
    
    @objc
    private func handleSwipe(_ recognizer: UIScreenEdgePanGestureRecognizer) {
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
