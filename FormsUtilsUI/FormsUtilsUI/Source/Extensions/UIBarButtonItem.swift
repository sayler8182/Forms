//
//  UIBarButtonItem.swift
//  FormsUtilsUI
//
//  Created by Konrad on 8/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UIBarButtonItem
public extension UIBarButtonItem { }

// MARK: UIBarButtonItemFocusable
public protocol UIBarButtonItemFocusable {
    func lostFocus()
}

// MARK: BarButtonItem
open class BarButtonItem: UIBarButtonItem {
    public static var flexible: BarButtonItem {
        return BarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    public weak var superview: UIView? = nil
    public var lostFocusOnClick: Bool = true
    public var onClick: (() -> Void)? = nil
    
    override public init() {
        super.init()
        self.setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    public init(image: UIImage?) {
        super.init()
        self.image = image
        self.setupView()
    }
    
    public init(imageName: String) {
        super.init()
        self.image = UIImage.from(name: imageName)
        self.setupView()
    }
    
    public init(title: String?) {
        super.init()
        self.title = title
        self.setupView()
    }
    
    open func setupView() {
        self.target = self
        self.action = #selector(handleOnClick)
    }
    
    @objc
    private func handleOnClick() {
        self.lostFocusIfNeeded()
        self.onClick?()
    }
    
    private func lostFocusIfNeeded() {
        guard self.lostFocusOnClick else { return }
        guard let superview = self.superview as? UIBarButtonItemFocusable else { return }
        superview.lostFocus()
    }
}

// MARK: Builder
public extension BarButtonItem {
    func with(image: UIImage?) -> Self {
        self.image = image
        return self
    }
    func with(imageName: String) -> Self {
        self.image = UIImage.from(name: imageName)
        return self
    }
    func with(lostFocusOnClick: Bool) -> Self {
        self.lostFocusOnClick = lostFocusOnClick
        return self
    }
    func with(title: String?) -> Self {
        self.title = title
        return self
    }
}
