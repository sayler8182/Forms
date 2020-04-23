//
//  DemoTransitionViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import Transition
import UIKit

// MARK: DemoTransitionViewController
class DemoTransitionViewController: TransitionNavigationController {
    private let changeButton = Components.button.default()
        .with(title: "Change")
    
    override func setupConfiguration() {
        super.setupConfiguration()
        self.viewControllers = [FirstController()]
        self.animator = SlideHorizontalAnimator()
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
        self.changeButton.onClick = { [unowned self] in
            if self.viewControllers.count == 1 {
                self.pushViewController(SecondController(), animated: true)
            } else {
                self.popToRootViewController(animated: true)
            }
        }
    }
}

// MARK: FirstController
private class FirstController: ViewController {
    private let contentView = Components.container.view()
        .with(backgroundColor: UIColor.red)
        .with(viewKey: "contentView")
    private let titleLabel = Components.label.default()
        .with(alignment: .center)
        .with(text: "First title")
    private let detailsLabel = Components.label.default()
        .with(color: .lightGray)
        .with(font: UIFont.systemFont(ofSize: 12))
        .with(alignment: .center)
        .with(text: "First details")
        .with(viewKey: "detailsLabel")
    
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
    }
}

// MARK: SecondController
private class SecondController: ViewController {
    private let contentView = Components.container.view()
        .with(backgroundColor: UIColor.green)
        .with(cornerRadius: 16)
        .with(viewKey: "contentView")
    private let titleLabel = Components.label.default()
        .with(alignment: .center)
        .with(text: "Second title")
    private let detailsLabel = Components.label.default()
        .with(color: .lightGray)
        .with(font: UIFont.systemFont(ofSize: 12))
        .with(alignment: .center)
        .with(text: "Second details")
        .with(viewKey: "detailsLabel")
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.contentView, with: [
            Anchor.to(self.view).top.safeArea.offset(16),
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
