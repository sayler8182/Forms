//
//  SideMenuSlideAnimator.swift
//  SideMenu
//
//  Created by Konrad on 4/29/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: SideMenuSlideAnimator
internal class SideMenuSlideAnimator: SideMenuAnimator {
    override internal func prepare() {
        guard self.state == .closed else { return }
        if let leftSide: UIViewController = self.leftSide {
            leftSide.view.frame.size.width = self.leftSideWidth
            leftSide.view.frame.origin.x = -self.leftSideWidth
            leftSide.view.alpha = 0
        }
        if let rightSide: UIViewController = self.rightSide {
            rightSide.view.frame.size.width = self.rightSideWidth
            rightSide.view.frame.origin.x = self.content.view.frame.width
            rightSide.view.alpha = 0
        }
        if let overlayView: UIView = self.overlayView {
            overlayView.alpha = 0
        }
    }
    
    override internal func openLeft(animated: Bool = true,
                                    completion: ((Bool) -> Void)? = nil) {
        guard self.state == .closed || self.state == .inProgress else { return }
        self.state = .inProgress
        self.content.view.addSubview(self.overlayView, with: [
            Anchor.to(self.content.view).fill
        ])
        self.controller.view.animation(
            true,
            duration: self.animationTime,
            animations: {
                self.leftSide.view.alpha = 1
                self.overlayView.alpha = 1
                self.leftSide.view.frame.origin.x = 0
                self.content.view.frame.origin.x = self.leftSideWidth
        }, completion: { (status) in
            self.state = .openedLeft
            completion?(status)
        })
    }
    
    override internal func openRight(animated: Bool = true,
                                     completion: ((Bool) -> Void)? = nil) {
        guard self.state == .closed || self.state == .inProgress else { return }
        self.state = .inProgress
        self.content.view.addSubview(self.overlayView, with: [
            Anchor.to(self.content.view).fill
        ])
        self.controller.view.animation(
            true,
            duration: self.animationTime,
            animations: {
                self.rightSide.view.alpha = 1
                self.overlayView.alpha = 1
                self.rightSide.view.frame.origin.x = self.content.view.frame.width - self.rightSideWidth
                self.content.view.frame.origin.x = -self.rightSideWidth
        }, completion: { (status) in
            self.state = .openedRight
            completion?(status)
        })
    }
    
    override internal func closeLeft(animated: Bool = true,
                                     completion: ((Bool) -> Void)? = nil) {
        guard self.state == .openedLeft || self.state == .inProgress else { return }
        self.state = .inProgress
        self.controller.view.animation(
            true,
            duration: self.animationTime,
            animations: {
                self.leftSide.view.alpha = 0
                self.overlayView.alpha = 0
                self.leftSide.view.frame.origin.x = -self.leftSideWidth
                self.content.view.frame.origin.x = 0
        }, completion: { (status) in
            self.overlayView.removeFromSuperview()
            self.state = .closed
            completion?(status)
        })
    }
    
    override internal func closeRight(animated: Bool = true,
                                      completion: ((Bool) -> Void)? = nil) {
        guard self.state == .openedRight || self.state == .inProgress else { return }
        self.state = .inProgress
        self.controller.view.animation(
            true,
            duration: self.animationTime,
            animations: {
                self.rightSide.view.alpha = 0
                self.overlayView.alpha = 0
                self.rightSide.view.frame.origin.x = self.content.view.frame.width
                self.content.view.frame.origin.x = 0
        }, completion: { (status) in
            self.overlayView.removeFromSuperview()
            self.state = .closed
            completion?(status)
        })
    }
    
    override internal func panLeft(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.overlayView)
        let translationX = min(-min(0, translation.x), self.leftSideWidth) // 0...self.leftSideWidth
        let progress: CGFloat = translationX / self.leftSideWidth
        guard recognizer.state != .ended else {
            if progress >= 0.5 {
                self.closeLeft()
            } else {
                self.openLeft()
            }
            return
        }
        
        self.controller.view.animation(
            true,
            duration: self.animationTime,
            animations: {
                self.leftSide.view.alpha = 1 - progress
                self.overlayView.alpha = 1 - progress
                self.leftSide.view.frame.origin.x = -translationX
                self.content.view.frame.origin.x = self.leftSideWidth - translationX
        })
    }
    
    override internal func panRight(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.overlayView)
        let translationX = min(max(0, translation.x), self.rightSideWidth) // 0...self.rightSideWidth
        let progress: CGFloat = translationX / self.rightSideWidth
        guard recognizer.state != .ended else {
            if progress >= 0.5 {
                self.closeRight()
            } else {
                self.openRight()
            }
            return
        }
        
        self.controller.view.animation(
            true,
            duration: self.animationTime,
            animations: {
                self.leftSide.view.alpha = 1 - progress
                self.overlayView.alpha = 1 - progress
                self.rightSide.view.frame.origin.x = self.content.view.frame.width - self.rightSideWidth + translationX
                self.content.view.frame.origin.x = -self.rightSideWidth + translationX
        })
    }
}
