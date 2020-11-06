//
//  NavigationBar.swift
//  Forms
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import FormsUtilsUI
import UIKit

private class BackBarItem: BarButtonItem, Clickable { }

private class EmptyBarItem: BackBarItem {
    override func setupView() { }
}

// MARK: NavigationBarRefreshable
public protocol NavigationBarRefreshable {
    func refreshNavigationBar()
}

// MARK: NavigationBar
open class NavigationBar: FormsComponent {
    public private(set) var navigationBar: UINavigationBar?
    public private(set) var navigationItem: UINavigationItem?
    
    private var _backgroundColor: UIColor? = nil
    override open var backgroundColor: UIColor? {
        get { return self._backgroundColor }
        set {
            self._backgroundColor = newValue
            self.navigationBar?.barTintColor = newValue
        }
    }
    private var _backgroundImage: UIImage? = nil
    open var backgroundImage: UIImage? {
        get { return self._backgroundImage }
        set {
            self._backgroundImage = newValue
            self.navigationBar?.setBackgroundImage(newValue, for: .default)
        }
    }
    open var backImage: LazyImage? = nil {
        didSet { self.updateBackBarButton() }
    }
    open var closeImage: LazyImage? = nil {
        didSet { self.updateBackBarButton() }
    }
    open var isBack: Bool = true {
        didSet { self.updateLeftBarButtonItems() }
    }
    open var isShadow: Bool = true {
        didSet { self.updateShadow() }
    }
    open var isTranslucent: Bool = false {
        didSet { self.navigationBar?.isTranslucent = self.isTranslucent }
    }
    open var leftBarButtonItems: [BarButtonItem] = [] {
        didSet { self.updateLeftBarButtonItems() }
    }
    open var progress: CGFloat = 0.0
    open var rightBarButtonItems: [BarButtonItem] = [] {
        didSet { self.updateRightBarButtonItems() }
    }
    override open var tintColor: UIColor? {
        get { return super.tintColor }
        set {
            super.tintColor = newValue
            self.navigationBar?.tintColor = newValue
        }
    }
    open var title: String? = nil {
        didSet { self.navigationItem?.title = self.title }
    }
    open var titleAttributes: [NSAttributedString.Key: Any]? = nil {
        didSet { self.navigationBar?.titleTextAttributes = self.titleAttributes }
    }
    open var titleView: UIView? = nil {
        didSet { self.navigationItem?.titleView = self.titleView }
    }
    
    public var onBack: (() -> Void)? = nil 
    
    public func setNavigationBar(_ navigationBar: UINavigationBar?) {
        self.navigationBar = navigationBar
        self.updateShadow()
        navigationBar?.isTranslucent = self.isTranslucent
        navigationBar?.titleTextAttributes = self.titleAttributes
        navigationBar?.barTintColor = self.backgroundColor
        navigationBar?.tintColor = self.tintColor
        navigationBar?.setBackgroundImage(self.backgroundImage, for: .default)
    }
    
    public func setNavigationItem(_ navigationItem: UINavigationItem?) {
        self.navigationItem = navigationItem
        self.updateLeftBarButtonItems()
        self.updateRightBarButtonItems()
        self.updateTitle()
    }
    
    public func updateProgress(animated: Bool) {
        self.navigationBar?.progressBar?.setProgress(self.progress, animated: animated)
    } 
    
    private func updateBackBarButton() {
        let items: [UIBarItem] = self.navigationItem?.leftBarButtonItems ?? []
        let hasElements: Bool = items.isNotEmpty
        let hasEmptyElement: Bool = items.count(of: BackBarItem.self).equal(1)
        let controller: UINavigationController? = self.navigationBar?.parentNavigationController
        let canGoBack: Bool = controller?.viewControllers.count.greaterThan(1) ?? false
        let canDismiss: Bool = controller?.presentingViewController != nil
        let shouldOverrideBack: Bool = self.isBack && (canGoBack || canDismiss)
        if hasEmptyElement && shouldOverrideBack {
            self.navigationItem?.leftBarButtonItems = []
        } else if !hasElements && !shouldOverrideBack {
            self.navigationItem?.leftBarButtonItems = [EmptyBarItem()]
        } else if !hasElements && shouldOverrideBack {
            let image: UIImage? = canGoBack
                ? self.backImage?()
                : self.closeImage?()
            let item = BarButtonItem(image: image)
            item.onClick = Unowned(self) { (_self) in
                if let onBack = _self.onBack {
                    onBack()
                } else if canGoBack {
                    _self.navigationBar?.parentNavigationController?.popViewController(animated: true)
                } else if canDismiss {
                    _self.navigationBar?.parentController?.dismiss(animated: true, completion: nil)
                }
            }
            self.navigationItem?.leftBarButtonItems = [item]
        }
    }
    
    private func updateLeftBarButtonItems() {
        self.navigationItem?.leftBarButtonItems = self.leftBarButtonItems
        self.updateBackBarButton()
    }
    
    private func updateRightBarButtonItems() {
        self.navigationItem?.rightBarButtonItems = self.rightBarButtonItems
    }
    
    private func updateTitle() {
        self.navigationItem?.title = nil
        if let title: String = self.title {
            self.navigationItem?.title = title
        }
        if let titleView: UIView = self.titleView {
            self.navigationItem?.titleView = titleView
        }
    }
    
    private func updateShadow() {
        self.navigationBar?.setValue(!self.isShadow, forKey: "hidesShadow")
    }
}

// MARK: Builder
public extension NavigationBar {
    @objc
    override func with(backgroundColor: UIColor?) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }
    @objc
    func with(backgroundImage: UIImage?) -> Self {
        self.backgroundImage = backgroundImage
        return self
    }
    func with(backImage: LazyImage?) -> Self {
        self.backImage = backImage
        return self
    }
    func with(closeImage: LazyImage?) -> Self {
        self.closeImage = closeImage
        return self
    }
    func with(isBack: Bool) -> Self {
        self.isBack = isBack
        return self
    }
    func with(isShadow: Bool) -> Self {
        self.isShadow = isShadow
        return self
    }
    func with(isTranslucent: Bool) -> Self {
        self.isTranslucent = isTranslucent
        return self
    }
    func with(leftBarButtonItems: [BarButtonItem]) -> Self {
        self.leftBarButtonItems = leftBarButtonItems
        return self
    }
    func with(progress: CGFloat) -> Self {
        self.progress = progress
        return self
    }
    func with(progressCurrent: Int?, progressCount: Int?) -> Self {
        guard let progressCurrent: Int = progressCurrent else { return self }
        guard let progressCount: Int = progressCount else { return self }
        self.progress = CGFloat(progressCurrent) / CGFloat(progressCount)
        return self
    }
    func with(rightBarButtonItems: [BarButtonItem]) -> Self {
        self.rightBarButtonItems = rightBarButtonItems
        return self
    }
    func with(tintColor: UIColor?) -> Self {
        self.tintColor = tintColor
        return self
    }
    func with(title: String?) -> Self {
        self.title = title
        return self
    }
    func with(titleView: UIView?) -> Self {
        self.titleView = titleView
        return self
    }
}
