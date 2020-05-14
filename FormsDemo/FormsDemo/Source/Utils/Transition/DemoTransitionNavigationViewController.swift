//
//  DemoTransitionNavigationViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import Forms
import Transition
import UIKit

// MARK: DemoTransitionNavigationViewController
class DemoTransitionNavigationViewController: FormsNavigationController, TransitionableNavigation {
    var animator: TransitionNavigationAnimator = TransitionNavigationSlideHorizontalAnimator()
    var coordinator: TransitionNavigationCoordinator = TransitionNavigationCoordinator()
    var edgePanGesture: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
    
    private let changeButton = Components.button.default()
        .with(title: "Change")
    
    override func postInit() {
        super.postInit()
        self.delegate = self.coordinator
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
        
        self.changeButton.onClick = { [unowned self] in
            if self.viewControllers.count == 1 {
                self.pushViewController(DemoSecondController(), animated: true)
            } else {
                self.popToRootViewController(animated: true)
            }
        }
    }
    
    @objc
    func handleTransitionBackSwipe(recognizer: UIScreenEdgePanGestureRecognizer) {
        self.handleTransitionNavigationEdgePan(recognizer)
    }
}

// MARK: DemoFirstController
private class DemoFirstController: FormsViewController {
    private let progressBar = Components.progress.progressBar()
        .with(progress: 1.0 / 2.0)
        .with(viewKey: "progressBar")
    private let contentView = Components.container.view()
        .with(backgroundColor: UIColor.red)
        .with(viewKey: "contentView")
    private let titleLabel = Components.label.default()
        .with(alignment: .center)
        .with(text: "First title")
    private let detailsLabel = Components.label.default()
        .with(color: .lightGray)
        .with(font: Theme.Fonts.regular(ofSize: 12))
        .with(alignment: .center)
        .with(text: "First details")
        .with(viewKey: "detailsLabel")
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.progressBar, with: [
            Anchor.to(self.view).top.safeArea,
            Anchor.to(self.view).horizontal
        ])
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
    }
}

// MARK: DemoSecondController
private class DemoSecondController: FormsViewController {
    private let progressBar = Components.progress.progressBar()
        .with(progress: 2.0 / 2.0)
        .with(viewKey: "progressBar")
    private let contentView = Components.container.view()
        .with(backgroundColor: UIColor.green)
        .with(cornerRadius: 16)
        .with(viewKey: "contentView")
    private let titleLabel = Components.label.default()
        .with(alignment: .center)
        .with(text: "Second title")
    private let detailsLabel = Components.label.default()
        .with(color: .lightGray)
        .with(font: Theme.Fonts.regular(ofSize: 12))
        .with(alignment: .center)
        .with(text: "Second details")
        .with(viewKey: "detailsLabel")
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.progressBar, with: [
            Anchor.to(self.view).top.safeArea,
            Anchor.to(self.view).horizontal
        ])
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
    }
}
