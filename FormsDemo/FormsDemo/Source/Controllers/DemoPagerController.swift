//
//  DemoPagerController.swift
//  FormsDemo
//
//  Created by Konrad on 4/6/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DemoPagerController
class DemoPagerController: PagerController {
    override func setupTopBar() {
        super.setupTopBar()
        self.topBarFillEqual = false
    }
    
    override func setupPageControl() {
        super.setupPageControl()
        self.showPageControl(animated: false)
    }
    
    override func setupItems() {
        super.setupItems()
        self.setItems([
            PagerItem(
                viewController: { [unowned self] in
                    let controller = ContentViewController()
                    controller.titleFirst = "Change page to second"
                    controller.onClickFirst = { [unowned self] in
                        self.showPage(at: 1)
                    }
                    controller.titleSecond = "Change page to out of range"
                    controller.onClickSecond = { [unowned self] in
                        self.showPage(at: Int.max)
                    }
                    return controller
                },
                title: "First",
                onSelect: { [unowned self] (_) in
                    self.isTranslucent = false
            }),
            PagerItem(
                viewController: { [unowned self] in
                    let controller = ContentViewController()
                    controller.titleFirst = "Show page control"
                    controller.onClickFirst = { [unowned self] in
                        self.showPageControl()
                    }
                    controller.titleSecond = "Hide page control"
                    controller.onClickSecond = { [unowned self] in
                        self.hidePageControl()
                    }
                    return controller
                },
                title: "Second is longer",
                onSelect: { [unowned self] (_) in
                    self.isTranslucent = true
            }),
            PagerItem(
                viewController: { [unowned self] in
                    let controller = ContentViewController()
                    controller.titleFirst = "Show top bar"
                    controller.onClickFirst = { [unowned self] in
                        self.showTopBar()
                    }
                    controller.titleSecond = "Hide top bar"
                    controller.onClickSecond = { [unowned self] in
                        self.hideTopBar()
                    }
                    return controller
                },
                title: "Third"
            ),
            PagerItem(
                viewController: { UIViewController() },
                title: "Forth also long"
            ),
            PagerItem(
                viewController: { UIViewController() },
                title: "Fifth"
            )
        ])
    }
}

// MARK: ContentViewController
private class ContentViewController: TableViewController {
    private lazy var navigationBar = Components.navigationBar.navigationBar()
    
    private let firstButton = Components.button.primary()
        .with(title: "Tap me")
    private let secondButton = Components.button.primary()
        .with(title: "Tap me")
    
    private let divider = Components.utils.divider()
        .with(height: 5)
    
    var titleFirst: String? {
        get { return self.firstButton.title }
        set { self.firstButton.title = newValue }
    }
    var titleSecond: String? {
        get { return self.secondButton.title }
        set { self.secondButton.title = newValue }
    }
    override var title: String? {
        get { return self.navigationBar.title }
        set { self.navigationBar.title = newValue }
    }
    
    var onClickFirst: (() -> Void)? = nil
    var onClickSecond: (() -> Void)? = nil
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.divider,
            self.onClickFirst.isNotNil ? self.firstButton : nil,
            self.onClickSecond.isNotNil ? self.secondButton : nil
        ], divider: self.divider)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.setNavigationBar(self.navigationBar)
    }
    
    override func setupActions() {
        super.setupActions()
        self.firstButton.onClick = { [unowned self] in
            self.onClickFirst?()
        }
        self.secondButton.onClick = { [unowned self] in
            self.onClickSecond?()
        }
    }
}
