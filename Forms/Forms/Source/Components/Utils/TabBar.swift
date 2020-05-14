//
//  TabBar.swift
//  Forms
//
//  Created by Konrad on 4/6/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import UIKit

// MARK: TabBarKey
public protocol TabBarKey {
    var rawValue: String { get }
    var keys: [TabBarItemKey] { get }
}

public protocol TabBarItemKey {
    var rawValue: String { get }
}

private enum TabBarDefaultKey: String, TabBarKey {
    case _noneKey
    
    var keys: [TabBarItemKey] {
        return []
    }
}

// MARK: TabBarItem
open class TabBarItem {
    private var _viewControllerFactory: () -> UIViewController
    public var index: Int = -1
    public var key: TabBarKey = TabBarDefaultKey._noneKey
    public let itemKey: TabBarItemKey
    public let image: UIImage?
    public let selectedImage: UIImage?
    public let title: String?
    public let isTranslucent: Bool
    public let onSelect: TabBar.OnSelect?
    
    private var _viewController: UIViewController?
    public var viewController: UIViewController {
        if self._viewController.isNil {
            self._viewController = self._viewControllerFactory()
        }
        return self._viewController! // swiftlint:disable:this force_unwrapping
    }
    
    public init(itemKey: TabBarItemKey,
                viewController: @escaping () -> UIViewController,
                image: UIImage?,
                selectedImage: UIImage? = nil,
                title: String? = nil,
                isTranslucent: Bool = false,
                onSelect: TabBar.OnSelect? = nil) {
        self.itemKey = itemKey
        self._viewControllerFactory = viewController
        self.image = image
        self.selectedImage = selectedImage
        self.title = title
        self.isTranslucent = isTranslucent
        self.onSelect = onSelect
    }
    
    public func isEqual(_ key: TabBarKey, _ itemKey: TabBarItemKey) -> Bool {
        return self.key.rawValue == key.rawValue && self.itemKey.rawValue == itemKey.rawValue
    }
    
    fileprivate func release() {
        self._viewController = nil
    }
}

// MARK: TabBar
open class TabBar: UITabBar {
    public typealias OnSelect = ((_ item: TabBarItem) -> Void)
    public typealias ShouldSelect = ((_ item: TabBarItem) -> Bool)
    
    private let contentView = UIView()
    private let stackView = UIStackView()
    
    open var imageColor: UIColor? {
        didSet { self.updateItems() }
    }
    open var imageSelectedColor: UIColor? {
        didSet { self.updateItems() }
    }
    open var titleColor: UIColor? {
        didSet { self.updateItems() }
    }
    open var titleFont: UIFont = Theme.Fonts.regular(ofSize: 10) {
        didSet { self.updateItems() }
    }
    open var titleSelectedColor: UIColor? {
        didSet { self.updateItems() }
    }
    open var titleSelectedFont: UIFont = Theme.Fonts.regular(ofSize: 10) {
        didSet { self.updateItems() }
    }
    
    private var tabBarItems: [TabBarItem] = []
    private var selectedIndex: Int? = nil
    
    public var onSelect: OnSelect? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    open func setupView() {
        self.clipsToBounds = true
        self.addSubview(self.contentView, with: [
            Anchor.to(self).top.horizontal,
            Anchor.to(self).bottom.offset(UIView.safeArea.bottom),
            Anchor.to(self.contentView).height(44)
        ])
        self.stackView.alignment = UIStackView.Alignment.fill
        self.stackView.axis = NSLayoutConstraint.Axis.horizontal
        self.stackView.distribution = UIStackView.Distribution.fillEqually
        self.contentView.addSubview(self.stackView, with: [
            Anchor.to(self.contentView).fill
        ])
    }
    
    public func selectIndex(_ index: Int) {
        self.selectedIndex = index
        self.updateItems()
    }
    
    public func setItems(_ items: [TabBarItem],
                         index: Int = 0) {
        self.tabBarItems = items
        self.stackView.removeSubviews()
        for i in 0..<items.count {
            let itemView: UIView = self.createItem(index: i)
            self.stackView.addArrangedSubview(itemView)
        }
        self.selectIndex(index)
    }
    
    @objc
    private func handleItemSelect(_ recognizer: UITapGestureRecognizer) {
        guard let index: Int = recognizer.view?.tag else { return }
        let item: TabBarItem = self.tabBarItems[index]
        self.onSelect?(item)
    }
    
    private func createItem(index: Int) -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.tag = index
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleItemSelect))
        view.addGestureRecognizer(gesture)
        let contentView = UIView()
        view.addSubview(contentView, with: [
            Anchor.to(view).center
        ])
        let imageView = UIImageView()
        contentView.addSubview(imageView, with: [
            Anchor.to(contentView).top.horizontal
        ])
        let titleLabel = UILabel()
        contentView.addSubview(titleLabel, with: [
            Anchor.to(imageView).topToBottom,
            Anchor.to(contentView).bottom.horizontal
        ])
        return view
    }
    
    private func updateItems() {
        guard self.tabBarItems.count == self.stackView.arrangedSubviews.count else { return }
        for (i, view) in self.stackView.arrangedSubviews.enumerated() {
            let isSelected: Bool = i == self.selectedIndex
            let item: TabBarItem? = self.tabBarItems[safe: i]
            let contentView: UIView? = view.subviews[safe: 0]
            let imageView: UIImageView? = contentView?.subviews[safe: 0] as? UIImageView
            imageView?.image = isSelected
                ? item?.selectedImage?.asTemplate ?? item?.image?.asTemplate
                : item?.image?.asTemplate
            imageView?.tintColor = isSelected
                ? self.imageSelectedColor
                : self.imageSelectedColor
            imageView?.contentMode = .center
            let titleLabel: UILabel? = contentView?.subviews[safe: 1] as? UILabel
            titleLabel?.textAlignment = .center
            titleLabel?.text = item?.title
            titleLabel?.textColor = isSelected
                ? self.titleSelectedColor
                : self.titleColor
            titleLabel?.font = isSelected
                ? self.titleSelectedFont
                : self.titleFont
        }
    }
}
