//
//  NavigationBar.swift
//  Forms
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: BarItem
open class BarItem: UIBarButtonItem, Clickable {
    public var onClick: (() -> Void)? = nil
    
    override public init() {
        super.init()
        self.setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    open func setupView() {
        self.target = self
        self.action = #selector(handleOnClick)
    }
    
    @objc
    private func handleOnClick() {
        self.onClick?()
    }
    
    public func with(image: UIImage?) -> Self {
        self.image = image
        return self
    }

    public func with(imageSystemName: String) -> Self {
        self.image = UIImage(systemName: imageSystemName)
        return self
    }
    
    public func with(title: String?) -> Self {
        self.title = title
        return self
    }
}

private class BackBarItem: BarItem { }
    
private class EmptyBarItem: BackBarItem {
    override func setupView() { }
}

// MARK: NavigationBar
open class NavigationBar: FormsComponent {
    private var navigationBar: UINavigationBar?
    private var navigationItem: UINavigationItem?
    
    private var _backgroundColor: UIColor? = nil
    override open var backgroundColor: UIColor? {
        get { return self._backgroundColor }
        set {
            self._backgroundColor = newValue
            self.navigationBar?.barTintColor = newValue
        }
    }
    open var backImage: (() -> UIImage?)? = nil {
        didSet { self.updateBackBarButton() }
    }
    open var closeImage: (() -> UIImage?)? = nil {
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
    open var leftBarButtonItems: [BarItem] = [] {
        didSet { self.updateLeftBarButtonItems() }
    }
    open var rightBarButtonItems: [BarItem] = [] {
        didSet { self.updateRightBarButtonItems() }
    }
    private var _tintColor: UIColor? = nil
    override open var tintColor: UIColor? {
        get { return self._tintColor }
        set {
            self._tintColor = newValue
            self.navigationBar?.tintColor = newValue
        }
    }
    open var title: String? = nil {
        didSet { self.updateTitle() }
    }
    open var titleView: UIView? = nil {
        didSet { self.updateTitle() }
    }
    
    public var onBack: (() -> Void)? = nil 
    
    public func setNavigationBar(_ navigationBar: UINavigationBar?) {
        self.navigationBar = navigationBar
        self.updateShadow()
        navigationBar?.isTranslucent = self.isTranslucent
        navigationBar?.barTintColor = self.backgroundColor
        navigationBar?.tintColor = self.tintColor
    }
    
    public func setNavigationItem(_ navigationItem: UINavigationItem?) {
        self.navigationItem = navigationItem
        self.updateLeftBarButtonItems()
        self.updateRightBarButtonItems()
        self.updateTitle()
    }
    
    private func updateBackBarButton() {
        let items: [UIBarItem] = self.navigationItem?.leftBarButtonItems ?? []
        let hasElements: Bool = items.isNotEmpty
        let hasEmptyElement: Bool = items.count(of: BackBarItem.self).equal(1)
        if hasEmptyElement && self.isBack {
            self.navigationItem?.leftBarButtonItems = []
        } else if !hasElements && !self.isBack {
            self.navigationItem?.leftBarButtonItems = [EmptyBarItem()]
        } else if !hasElements && self.isBack && (self.backImage.isNotNil || self.closeImage.isNotNil) {
            let controller: UINavigationController? = self.navigationBar?.parentNavigationController
            let canGoBack: Bool = controller?.viewControllers.count.greaterThan(1) ?? false
            let image: UIImage? = canGoBack
                ? self.backImage?()
                : self.closeImage?()
            let item = BarItem().with(image: image)
            item.onClick = { [unowned self] in
                if let onBack = self.onBack {
                    onBack()
                } else if canGoBack {
                    self.navigationBar?.parentNavigationController?.popViewController(animated: true)
                } else {
                    self.navigationBar?.parentController?.dismiss(animated: true, completion: nil)
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
        self.navigationItem?.title = self.title
        self.navigationItem?.titleView = self.titleView
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
    func with(backImage: (() -> UIImage?)?) -> Self {
        self.backImage = backImage
        return self
    }
    func with(closeImage: (() -> UIImage?)?) -> Self {
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
    func with(leftBarButtonItems: [BarItem]) -> Self {
        self.leftBarButtonItems = leftBarButtonItems
        return self
    }
    func with(rightBarButtonItems: [BarItem]) -> Self {
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
