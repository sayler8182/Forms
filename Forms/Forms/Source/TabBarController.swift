//
//  TabBarController.swift
//  Forms
//
//  Created by Konrad on 4/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import UIKit

// MARK: TabBarController
open class TabBarController: ViewController {
    private let container = UIView(width: 320, height: 400)
    private let tabBar = TabBar(width: 320, height: 72)
    
    private let containerBottomAnchor = AnchorConnection()
    private let containerToTabBarBottomAnchor = AnchorConnection()
    private let tabBarBottomAnchor = AnchorConnection()
    
    private var items: [String: [TabBarItem]] = [:]
    private var selectedIndex: Int = 0
    private var selectedKey: TabBarKey? = nil
    
    open var backgroundColor: UIColor? = UIColor.systemBackground {
        didSet { self.container.backgroundColor = self.backgroundColor }
    }
    open var isTranslucent: Bool = false {
        didSet { self.updateTranslucent() }
    }
    open var tabBarBackgroundColor: UIColor? = UIColor.systemBackground {
        didSet { self.tabBar.backgroundColor = self.tabBarBackgroundColor }
    }
    open var tabBarImageColor: UIColor? = UIColor.label {
        didSet { self.tabBar.imageColor = self.tabBarImageColor }
    }
    open var tabBarImageSelectedColor: UIColor? = UIColor.label {
        didSet { return self.tabBar.imageSelectedColor = self.tabBarImageSelectedColor }
    }
    open var tabBarTitleColor: UIColor? = UIColor.label {
        didSet { self.tabBar.titleColor = self.tabBarTitleColor }
    }
    open var tabBarTitleFont: UIFont = UIFont.systemFont(ofSize: 10) {
        didSet { self.tabBar.titleFont = self.tabBarTitleFont }
    }
    open var tabBarTitleSelectedColor: UIColor? = UIColor.label {
        didSet { return self.tabBar.titleSelectedColor = self.tabBarTitleSelectedColor }
    }
    open var tabBarTitleSelectedFont: UIFont = UIFont.boldSystemFont(ofSize: 10) {
        didSet { return self.tabBar.titleSelectedFont = self.tabBarTitleSelectedFont }
    }
    
    public var onSelect: TabBar.OnSelect? = nil
    public var shouldSelect: (TabBar.ShouldSelect) = { _ in true }
    
    override public func setupContent() {
        super.setupContent()
        self.setupContainer()
        self.setupTabBar()
        self.setupSets()
    }
    
    open func setupContainer() {
        self.container.backgroundColor = self.backgroundColor
        self.view.addSubview(self.container, with: [
            Anchor.to(self.view).top.safeArea,
            Anchor.to(self.view).horizontal,
            Anchor.to(self.view).bottom
                .connect(self.containerBottomAnchor)
                .isActive(false)
        ])
    }
    
    open func setupTabBar() {
        self.tabBar.backgroundColor = self.tabBarBackgroundColor
        self.tabBar.imageColor = self.tabBarImageColor
        self.tabBar.imageSelectedColor = self.tabBarImageSelectedColor
        self.tabBar.titleColor = self.tabBarTitleColor
        self.tabBar.titleFont = self.tabBarTitleFont
        self.tabBar.titleSelectedColor = self.tabBarTitleSelectedColor
        self.tabBar.titleSelectedFont = self.tabBarTitleSelectedFont
        self.view.addSubview(self.tabBar, with: [
            Anchor.to(self.container).topToBottom
                .connect(self.containerToTabBarBottomAnchor)
                .priority(.defaultHigh),
            Anchor.to(self.view).horizontal,
            Anchor.to(self.view).bottom.connect(self.tabBarBottomAnchor)
        ])
    }
    
    open func setupSets() {
        // HOOK
    }
    
    override open func setupActions() {
        super.setupActions()
        self.tabBar.onSelect = { [unowned self] (item) in
            guard self.shouldSelect(item) else { return }
            self.showContentController(index: item.index)
        }
    }
    
    public func show(_ key: TabBarKey? = nil,
                     itemKey: TabBarItemKey) {
        guard let key = key ?? self.selectedKey else { return }
        guard let items = self.items[key.rawValue] else { return }
        guard let item = items.enumerated().first(where: { $0.element.itemKey.rawValue == itemKey.rawValue }) else { return }
        guard self.shouldSelect(item.element) else { return }
        self.selectedKey = key
        self.selectedIndex = item.offset
        self.tabBar.setItems(items, index: item.offset)
        self.showContentController(index: item.offset)
    }
    
    public func show(_ key: TabBarKey? = nil,
                     index: Int) {
        guard let key = key ?? self.selectedKey else { return }
        guard let items: [TabBarItem] = self.items[key.rawValue] else { return }
        guard let item: TabBarItem = items[safe: index] else { return }
        guard self.shouldSelect(item) else { return }
        self.selectedKey = key
        self.selectedIndex = index
        self.tabBar.setItems(items, index: index)
        self.showContentController(index: index)
    }
    
    public func addSet(_ set: [TabBarItem],
                       forKey key: TabBarKey) {
        set.enumerated().forEach { (i, item) in
            item.index = i
            item.key = key
        }
        self.items[key.rawValue] = set
    }
    
    public func removeSet(_ key: TabBarKey) {
        self.items.removeValue(forKey: key.rawValue)
    }
    
    private func showContentController(index: Int) {
        guard let key: TabBarKey = self.selectedKey else { return }
        guard let item: TabBarItem = self.items[key.rawValue]?[index] else { return }
        self.children.forEach { self.hideContentController($0) }
        self.showContentController(item.viewController)
        self.selectedIndex = index
        self.isTranslucent = item.isTranslucent
        self.tabBar.selectIndex(index)
        self.onSelect?(item)
        item.onSelect?(item)
    }
    
    private func showContentController(_ content: UIViewController) {
        self.addChild(content)
        content.view.frame = self.container.bounds
        self.container.addSubview(content.view, with: [
            Anchor.to(self.container).fill
        ])
        content.didMove(toParent: self)
    }
    
    private func hideContentController(_ content: UIViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }
    
    private func updateTranslucent() {
        self.tabBar.isTranslucent = self.isTranslucent
        self.containerToTabBarBottomAnchor.constraint?.isActive = !self.isTranslucent
        self.containerBottomAnchor.constraint?.isActive = self.isTranslucent
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
}

// MARK: TabBar
public extension TabBarController {
    func showTabBar(animated: Bool = true,
                    completion: ((Bool) -> Void)? = nil) {
        self.tabBar.isHidden = false
        self.view.animation(
            animated,
            duration: 0.3,
            animations: {
                self.tabBarBottomAnchor.constraint?.constant = 0
                self.tabBar.alpha = 1
                self.view.layoutIfNeeded()
        }, completion: { (status) in
            completion?(status)
        })
    }
    
    func hideTabBar(animated: Bool = true,
                    completion: ((Bool) -> Void)? = nil) {
        self.view.animation(
            animated,
            duration: 0.3,
            animations: {
                self.tabBarBottomAnchor.constraint?.constant = self.tabBar.frame.height
                self.tabBar.alpha = 0
                self.view.layoutIfNeeded()
        }, completion: { (status) in
            self.tabBar.isHidden = true
            completion?(status)
        })
    }
}

// MARK: UIViewController
extension UIViewController {
    func getTabBarController<T: TabBarController>(of type: T.Type) -> T? {
        var controller: UIViewController? = self.parent
        while controller.isNotNil && !(controller is T) {
            controller = controller?.parent
        }
        return controller as? T
    }
}
