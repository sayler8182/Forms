//
//  DemoTransitionNavigationTableViewController.swift
//  FormsDemo
//
//  Created by Konrad on 6/19/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsTransitions
import FormsUtils
import UIKit

// MARK: DemoTransitionNavigationTableViewController
class DemoTransitionNavigationTableViewController: FormsNavigationController, TransitionableNavigation {
    var animator: TransitionNavigationAnimator = TransitionNavigationSlideHorizontalAnimator()
    var coordinator: TransitionNavigationCoordinator = TransitionNavigationCoordinator()
    var edgePanGesture: UIScreenEdgePanGestureRecognizer! = UIScreenEdgePanGestureRecognizer()
    
    private let changeButton = Components.button.default()
        .with(title: "Change")
    
    override func postInit() {
        super.postInit()
        self.delegate = self.coordinator
        self.modalPresentationStyle = .fullScreen
        self.setRoot(DemoFirstController())
    }
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.changeButton, with: [
            Anchor.to(self.view).horizontal,
            Anchor.to(self.view).bottom.safeArea
        ])
    }
    
    override func setupActions() {
        super.setupActions()
        self.edgePanGesture.addTarget(self, action: #selector(handleTransitionBackSwipe))
        self.edgePanGesture.edges = .left
        self.view.addGestureRecognizer(self.edgePanGesture)
        self.changeButton.onClick = Unowned(self) { (_self) in
            if _self.viewControllers.count == 1 {
                _self.pushViewController(DemoSecondController(), animated: true)
            } else {
                _self.popToRootViewController(animated: true)
            }
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.loadView()
        viewController.viewDidLoad()
        DispatchQueue.main.async {
            super.pushViewController(viewController, animated: animated)
            guard let controller = viewController as? NavigationBarRefreshable else { return }
            DispatchQueue.main.async {
                controller.refreshNavigationBar()
            }
        }
    }
    
    @objc
    func handleTransitionBackSwipe(recognizer: UIScreenEdgePanGestureRecognizer) {
        self.handleTransitionNavigationEdgePan(recognizer)
    }
}

// MARK: DemoFirstController
private class DemoFirstController: FormsTableViewController {
    private let navigationBar = Components.navigationBar.default()
    private let someBigLabel = Components.label.default()
        .with(alignment: .center)
        .with(marginTop: 44.0)
        .with(text: "Some Big Label")
    private let titleLabel = Components.label.default()
        .with(alignment: .center)
        .with(marginTop: 22.0)
        .with(text: "First title")
    private let detailsLabel = Components.label.default()
        .with(color: Theme.Colors.gray)
        .with(font: Theme.Fonts.regular(ofSize: 12))
        .with(alignment: .center)
        .with(text: "First details")
        .with(viewKey: "detailsLabel")
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.setNavigationBar(self.navigationBar)
    }
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.someBigLabel,
            self.titleLabel,
            self.detailsLabel
        ])
    }
}

// MARK: DemoSecondController
private class DemoSecondController: FormsTableViewController {
    private let navigationBar = Components.navigationBar.default()
    private let titleLabel = Components.label.default()
        .with(alignment: .center)
        .with(marginTop: 144.0)
        .with(text: "Second title")
    private let detailsLabel = Components.label.default()
        .with(color: Theme.Colors.gray)
        .with(font: Theme.Fonts.regular(ofSize: 12))
        .with(alignment: .center)
        .with(text: "Second details")
        .with(viewKey: "detailsLabel")
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.setNavigationBar(self.navigationBar)
    }
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.titleLabel,
            self.detailsLabel
        ])
    }
}
