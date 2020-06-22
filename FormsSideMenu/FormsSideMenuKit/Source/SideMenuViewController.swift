//
//  SideMenuViewController.swift
//  FormsSideMenu
//
//  Created by Konrad on 4/29/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: SideMenuAnimationType
public enum SideMenuAnimationType {
    case slide
    
    var animator: SideMenuAnimator {
        switch self {
        case .slide: return SideMenuSlideAnimator()
        }
    }
}

// MARK: SideMenuDirection
public enum SideMenuDirection {
    case left
    case right
}

// MARK: SideMenuState
enum SideMenuState {
    case inProgress
    case closed
    case openedLeft
    case openedRight
}

// MARK: SideMenuController
open class SideMenuController: FormsViewController {
    internal var leftSide: UIViewController = UIViewController()
    internal var rightSide: UIViewController = UIViewController()
    internal var content: UIViewController = UIViewController()
    internal var overlayView: UIView = UIView()
    private let panGestureRecognizer = UIPanGestureRecognizer()
    
    private lazy var animator: SideMenuAnimator = self.animationType.animator
    private var state: SideMenuState {
        return self.animator.state
    }
    
    open var animationTime: TimeInterval = 0.3 {
        didSet { self.animator.animationTime = self.animationTime }
    }
    open var animationType: SideMenuAnimationType = .slide {
        didSet {
            self.animator = self.animationType.animator
            self.configureAnimator()
        }
    }
    open var isDismissable: Bool {
        get { return self.panGestureRecognizer.isEnabled }
        set { self.panGestureRecognizer.isEnabled = newValue }
    }
    open var leftSideWidth: CGFloat = 300.0 {
        didSet { self.animator.leftSideWidth = self.leftSideWidth }
    }
    open var rightSideWidth: CGFloat = 300.0 {
        didSet { self.animator.rightSideWidth = self.rightSideWidth }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.content.willMove(toParent: self)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.content.didMove(toParent: self)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.content.willMove(toParent: nil)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.content.didMove(toParent: nil)
    }
    
    override open func setupContent() {
        super.setupContent()
        self.view.clipsToBounds = true
        self.configureAnimator()
    }
    
    override open func setupActions() {
        super.setupActions()
        self.overlayView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOverlay))
        self.overlayView.addGestureRecognizer(tapGestureRecognizer)
        self.panGestureRecognizer.addTarget(self, action: #selector(handlePanOverlay))
        self.overlayView.addGestureRecognizer(self.panGestureRecognizer)
    }
    
    override open func setTheme() {
        self.overlayView.backgroundColor = Theme.Colors.tertiaryLight.with(alpha: 0.3)
        super.setTheme()
    }
    
    public func setLeftSide(_ controller: UIViewController) {
        self.leftSide = controller
        controller.view.alpha = 0
        controller.view.frame = self.view.frame
        self.configureAnimator()
    }
    
    public func setRightSide(_ controller: UIViewController) {
        self.rightSide = controller
        controller.view.alpha = 0
        controller.view.frame = self.view.frame
        self.configureAnimator()
    }
    
    public func setContent(_ controller: UIViewController) {
        self.content = controller
        controller.view.frame = self.view.frame
        self.addChild(controller)
        self.view.addSubview(controller.view)
        self.configureAnimator()
    }
    
    public func open(direction: SideMenuDirection = .left,
                     animated: Bool = true,
                     completion: ((Bool) -> Void)? = nil) {
        self.animator.open(
            direction: direction,
            animated: animated,
            completion: completion)
    }
    
    public func close(animated: Bool = true,
                      completion: ((Bool) -> Void)? = nil) {
        if self.state == .openedLeft {
            self.animator.close(
                direction: .left,
                animated: animated,
                completion: completion)
        } else if self.state == .openedRight {
            self.animator.close(
                direction: .right,
                animated: animated,
                completion: completion)
        }
    }
    
    public func close(direction: SideMenuDirection,
                      animated: Bool = true,
                      completion: ((Bool) -> Void)? = nil) {
        self.animator.close(
            direction: direction,
            animated: animated,
            completion: completion)
    }
    
    @objc
    private func handleTapOverlay(recognizer: UITapGestureRecognizer) {
        self.close(animated: true)
    }
    
    @objc
    private func handlePanOverlay(recognizer: UIPanGestureRecognizer) {
        self.animator.handlePanOverlay(recognizer)
    }
    
    private func configureAnimator() {
        self.animator.controller = self
        self.animator.animationTime = self.animationTime
        self.animator.leftSideWidth = self.leftSideWidth
        self.animator.rightSideWidth = self.rightSideWidth
        self.animator.prepare()
    }
}

// MARK: UIViewController
public extension UIViewController {
    var sideMenuController: SideMenuController? {
        var controller: UIViewController? = self.parent
        while controller.isNotNil && !(controller is SideMenuController) {
            controller = controller?.parent
        }
        return controller as? SideMenuController
    }
}
