//
//  SideMenuAnimator.swift
//  SideMenu
//
//  Created by Konrad on 4/29/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: SideMenuAnimator
internal class SideMenuAnimator {
    internal var state: SideMenuState = .closed
    internal weak var controller: SideMenuController!
    
    internal var leftSide: UIViewController! {
        return self.controller?.leftSide
    }
    internal var rightSide: UIViewController! {
        return self.controller?.rightSide
    }
    internal var content: UIViewController! {
        return self.controller?.content
    }
    internal var overlayView: UIView! {
        return self.controller?.overlayView
    }
    
    internal var animationTime: TimeInterval = 0.3 
    internal var leftSideWidth: CGFloat = 300.0 {
        didSet { self.updateLeftSideWidth() }
    }
    internal var rightSideWidth: CGFloat = 300.0 {
        didSet { self.updateRightSideWidth() }
    }
    
    internal var panDirection: SideMenuDirection? = nil
    
    internal func prepare() {
        // HOOK
    }
    
    internal func open(direction: SideMenuDirection = .left,
                       animated: Bool = true,
                       completion: ((Bool) -> Void)? = nil) {
        switch direction {
        case .left: self.openLeft(animated: animated)
        case .right: self.openRight(animated: animated)
        }
    }
    
    internal func openLeft(animated: Bool = true,
                           completion: ((Bool) -> Void)? = nil) {
        // HOOK
    }
    
    internal func openRight(animated: Bool = true,
                            completion: ((Bool) -> Void)? = nil) {
        // HOOK
    }
    
    internal func close(direction: SideMenuDirection = .left,
                        animated: Bool = true,
                        completion: ((Bool) -> Void)? = nil) {
        switch direction {
        case .left: self.closeLeft(animated: animated)
        case .right: self.closeRight(animated: animated)
        }
    }
    
    internal func closeLeft(animated: Bool = true,
                            completion: ((Bool) -> Void)? = nil) {
        // HOOK
    }
    
    internal func closeRight(animated: Bool = true,
                             completion: ((Bool) -> Void)? = nil) {
        // HOOK
    }
    
    internal func handlePanOverlay(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            switch self.state {
            case .openedLeft:
                self.state = .inProgress
                self.panDirection = .left
                self.handlePanOverlay(recognizer, .left)
            case .openedRight:
                self.state = .inProgress
                self.panDirection = .right
                self.handlePanOverlay(recognizer, .right)
            default: self.panDirection = nil
            }
        case .changed:
            self.handlePanOverlay(recognizer, self.panDirection)
        case .ended:
            self.handlePanOverlay(recognizer, self.panDirection)
            self.panDirection = nil
        default:
            self.panDirection = nil
        }
    }
    
    private func handlePanOverlay(_ recognizer: UIPanGestureRecognizer,
                                  _ direction: SideMenuDirection?) {
        guard let direction = self.panDirection else { return }
        switch direction {
        case .left:
            self.panLeft(recognizer)
        case .right:
            self.panRight(recognizer)
        }
    }

    internal func panLeft(_ recognizer: UIPanGestureRecognizer) {
        // HOOK
    }

    internal func panRight(_ recognizer: UIPanGestureRecognizer) {
        // HOOK
    }
    
    private func updateLeftSideWidth() {
        guard let leftSide = self.leftSide else { return }
        leftSide.view.frame.size.width = self.leftSideWidth
    }
    
    private func updateRightSideWidth() {
        guard let rightSide = self.rightSide else { return }
        rightSide.view.frame.size.width = self.rightSideWidth
    }
}
