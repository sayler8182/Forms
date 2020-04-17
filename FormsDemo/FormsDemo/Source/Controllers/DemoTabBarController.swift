//
//  DemoTabBarController.swift
//  FormsDemo
//
//  Created by Konrad on 4/5/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: Keys
extension DemoTabBarController {
    enum TabBarKeys: String, TabBarKey {
        case main
        case other
        
        var keys: [TabBarItemKey] {
            switch self {
            case .main: return TabBarMainKeys.allCases
            case .other: return TabBarOtherKeys.allCases
            }
        }
    }
    enum TabBarMainKeys: String, TabBarItemKey, CaseIterable {
        case first
        case second
    }
    enum TabBarOtherKeys: String, TabBarItemKey, CaseIterable {
        case first
        case second
        case third
    }
}

// MARK: DemoTabBarController
class DemoTabBarController: TabBarController {
    override func setupView() {
        super.setupView()
        self.show(TabBarKeys.main, index: 0)
    }
    
    override func setupSets() {
        super.setupSets()
        self.addSet([
            TabBarItem(
                itemKey: TabBarMainKeys.first,
                viewController: { [unowned self] in
                    let controller = ContentViewController()
                    controller.titleFirst = "Change set to other"
                    controller.onClickFirst = { [unowned self] in
                        self.show(TabBarKeys.other, itemKey: TabBarOtherKeys.first)
                    }
                    return controller.with(navigationController: UINavigationController())
                },
                image: UIImage(systemName: "heart.fill"),
                selectedImage: UIImage(systemName: "heart.fill"),
                title: "First"
            ),
            TabBarItem(
                itemKey: TabBarMainKeys.second,
                viewController: { return UIViewController() },
                image: UIImage(systemName: "heart"),
                selectedImage: UIImage(systemName: "heart"),
                title: "Second",
                isTranslucent: true
            )
        ], forKey: TabBarKeys.main)
        self.addSet([
            TabBarItem(
                itemKey: TabBarOtherKeys.first,
                viewController: { [unowned self] in
                    let controller = ContentViewController()
                    controller.titleFirst = "Change set to main"
                    controller.onClickFirst = { [unowned self] in
                        self.show(TabBarKeys.main, itemKey: TabBarOtherKeys.first)
                    }
                    return controller.with(navigationController: UINavigationController())
                },
                image: UIImage(systemName: "square.and.arrow.up"),
                title: "First other"
            ),
            TabBarItem(
                itemKey: TabBarOtherKeys.second,
                viewController: { [unowned self] in
                    let controller = ContentViewController()
                    controller.titleFirst = "Select third"
                    controller.onClickFirst = { [unowned self] in
                        self.show(index: 2)
                    }
                    return controller.with(navigationController: UINavigationController())
                },
                image: UIImage(systemName: "arrow.up"),
                title: "Second other"
            ),
            TabBarItem(
                itemKey: TabBarOtherKeys.third,
                viewController: { [unowned self] in
                    let controller = ContentViewController()
                    controller.titleFirst = "Hide TabBar"
                    controller.onClickFirst = { [unowned self] in
                        self.hideTabBar()
                    }
                    controller.titleSecond = "Show TabBar"
                    controller.onClickSecond = { [unowned self] in
                        self.showTabBar()
                    }
                    return controller.with(navigationController: UINavigationController())
                },
                image: UIImage(systemName: "arrow.down"),
                title: "Third other"
            )
        ], forKey: TabBarKeys.other)
    }
    
    override func setupActions() {
        super.setupActions()
        self.shouldSelect = { [unowned self] (item) in
            if item.isEqual(TabBarKeys.main, TabBarMainKeys.second) {
                UIAlertController()
                    .with(title: "Second")
                    .with(message: "Can't select")
                    .with(action: "Ok")
                    .present(on: self)
                return false
            }
            return true
        }
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
