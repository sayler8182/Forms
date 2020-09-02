//
//  DemoTabBarKitController.swift
//  FormsDemo
//
//  Created by Konrad on 4/5/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsTabBarKit
import FormsUtils
import UIKit

// MARK: Keys
extension DemoTabBarKitController {
    enum TabBarKeys: String, TabBarKey {
        enum Main: String, TabBarItemKey, CaseIterable {
            case first
            case second
        }
        enum Other: String, TabBarItemKey, CaseIterable {
            case first
            case second
            case third
        }
        
        case main
        case other
        
        var keys: [TabBarItemKey] {
            switch self {
            case .main: return Main.allCases
            case .other: return Other.allCases
            }
        }
    }
}

// MARK: DemoTabBarKitController
class DemoTabBarKitController: TabBarController {
    override func setupView() {
        super.setupView()
        self.show(TabBarKeys.main, index: 0)
    }
    
    override func setupSets() {
        super.setupSets()
        self.addSet([
            TabBarItem(
                itemKey: TabBarKeys.Main.first,
                viewController: { [unowned self] in
                    let controller = ContentViewController()
                    controller.titleFirst = "Change set to other"
                    controller.onClickFirst = Unowned(self) { (_self) in
                        _self.show(TabBarKeys.other, itemKey: TabBarKeys.Other.first)
                    }
                    return controller.embeded
                },
                image: UIImage.from(name: "heart.fill"),
                selectedImage: UIImage.from(name: "heart.fill"),
                title: "First"
            ),
            TabBarItem(
                itemKey: TabBarKeys.Main.second,
                viewController: { return UIViewController() },
                image: UIImage.from(name: "heart"),
                selectedImage: UIImage.from(name: "heart"),
                title: "Second",
                isTranslucent: true
            )
        ], forKey: TabBarKeys.main)
        self.addSet([
            TabBarItem(
                itemKey: TabBarKeys.Main.first,
                viewController: { [unowned self] in
                    let controller = ContentViewController()
                    controller.titleFirst = "Change set to main"
                    controller.onClickFirst = Unowned(self) { (_self) in
                        _self.show(TabBarKeys.main, itemKey: TabBarKeys.Other.first)
                    }
                    return controller.embeded
                },
                image: UIImage.from(name: "square.and.arrow.up"),
                title: "First other"
            ),
            TabBarItem(
                itemKey: TabBarKeys.Other.second,
                viewController: { [unowned self] in
                    let controller = ContentViewController()
                    controller.titleFirst = "Select third"
                    controller.onClickFirst = Unowned(self) { (_self) in
                        _self.show(index: 2)
                    }
                    return controller.embeded
                },
                image: UIImage.from(name: "arrow.up"),
                title: "Second other"
            ),
            TabBarItem(
                itemKey: TabBarKeys.Other.third,
                viewController: { [unowned self] in
                    let controller = ContentViewController()
                    controller.titleFirst = "Hide TabBar"
                    controller.onClickFirst = Unowned(self) { (_self) in
                        _self.hideTabBar()
                    }
                    controller.titleSecond = "Show TabBar"
                    controller.onClickSecond = Unowned(self) { (_self) in
                        _self.showTabBar()
                    }
                    return controller.embeded
                },
                image: UIImage.from(name: "arrow.down"),
                title: "Third other"
            )
        ], forKey: TabBarKeys.other)
    }
    
    override func setupActions() {
        super.setupActions()
        self.shouldSelect = { [unowned self] (item) in
            if item.isEqual(TabBarKeys.main, TabBarKeys.Main.second) {
                UIAlertController(preferredStyle: .alert)
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
private class ContentViewController: FormsTableViewController {
    private let navigationBar = Components.navigationBar.default()
    private let firstButton = Components.button.default()
        .with(title: "Tap me")
    private let secondButton = Components.button.default()
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
        self.firstButton.onClick = Unowned(self) { (_self) in
            _self.onClickFirst?()
        }
        self.secondButton.onClick = Unowned(self) { (_self) in
            _self.onClickSecond?()
        }
    }
}
