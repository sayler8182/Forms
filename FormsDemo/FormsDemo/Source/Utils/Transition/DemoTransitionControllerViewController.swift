//
//  DemoTransitionControllerViewController.swift
//  FormsDemo
//
//  Created by Konrad on 5/6/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsTransitions
import UIKit

// MARK: DemoTransitionControllerViewController
class DemoTransitionControllerViewController: FormsViewController {
    private let contentView = Components.container.view()
        .with(backgroundColor: Theme.Colors.red)
        .with(viewKey: "contentView")
    private let titleLabel = Components.label.default()
        .with(alignment: .center)
        .with(text: "First title")
    private let detailsLabel = Components.label.default()
        .with(color: Theme.Colors.gray)
        .with(font: Theme.Fonts.regular(ofSize: 12))
        .with(alignment: .center)
        .with(text: "First details")
        .with(viewKey: "detailsLabel")
    private let showButton = Components.button.default()
        .with(title: "Show")
        .with(viewKey: "actionButton")
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.contentView, with: [
            Anchor.to(self.view).center(100)
        ])
        self.view.addSubview(self.detailsLabel, with: [
            Anchor.to(self.view).horizontal,
            Anchor.to(self.view).bottom.safeArea.offset(64)
        ])
        self.view.addSubview(self.titleLabel, with: [
            Anchor.to(self.view).horizontal,
            Anchor.to(self.detailsLabel).bottomToTop.offset(4)
        ])
        self.view.addSubview(self.showButton, with: [
            Anchor.to(self.view).horizontal,
            Anchor.to(self.view).bottom.safeArea
        ])
    }

    override func setupActions() {
        super.setupActions()
        
        self.showButton.onClick = { [unowned self] in
            let controller = DemoSecondNavigationController()
            controller.modalPresentationStyle = .custom
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
}

// MARK: DemoSecondNavigationController
private class DemoSecondNavigationController: FormsNavigationController, TransitionableController {
    var animator: TransitionControllerAnimator = TransitionControllerSlideVerticalAnimator()
    var coordinator: TransitionControllerCoordinator = TransitionControllerCoordinator()
    var edgePanGesture: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
    
    override func postInit() {
        super.postInit()
        self.transitioningDelegate = self.coordinator
        self.setRoot(DemoSecondViewController())
    }
    
    override func setupActions() {
        super.setupActions()
        
        self.edgePanGesture.addTarget(self, action: #selector(handleTransitionBackSwipe))
        self.edgePanGesture.edges = .left
        self.view.addGestureRecognizer(self.edgePanGesture)
    }
    
    @objc
    func handleTransitionBackSwipe(recognizer: UIScreenEdgePanGestureRecognizer) {
        self.handleTransitionControllerEdgePan(recognizer)
    }
}
    
// MARK: DemoSecondViewController
private class DemoSecondViewController: FormsViewController {
    private let contentView = Components.container.view()
        .with(backgroundColor: Theme.Colors.green)
        .with(cornerRadius: 16)
        .with(viewKey: "contentView")
    private let titleLabel = Components.label.default()
        .with(alignment: .center)
        .with(text: "Second title")
    private let detailsLabel = Components.label.default()
        .with(color: Theme.Colors.gray)
        .with(font: Theme.Fonts.regular(ofSize: 12))
        .with(alignment: .center)
        .with(text: "Second details")
        .with(viewKey: "detailsLabel")
    private let hideButton = Components.button.default()
        .with(title: "Hide")
        .with(viewKey: "actionButton")
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.contentView, with: [
            Anchor.to(self.view).top.safeArea.offset(32),
            Anchor.to(self.contentView).size(80),
            Anchor.to(self.view).centerX
        ])
        self.view.addSubview(self.detailsLabel, with: [
            Anchor.to(self.view).horizontal,
            Anchor.to(self.view).bottom.safeArea.offset(64)
        ])
        self.view.addSubview(self.titleLabel, with: [
            Anchor.to(self.view).horizontal,
            Anchor.to(self.detailsLabel).bottomToTop.offset(4)
        ])
        self.view.addSubview(self.hideButton, with: [
            Anchor.to(self.view).horizontal,
            Anchor.to(self.view).bottom.safeArea
        ])
    }
    
    override func setupActions() {
        super.setupActions()
        
        self.hideButton.onClick = { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
    }
}
