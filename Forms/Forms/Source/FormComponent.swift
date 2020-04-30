//
//  FormsComponent.swift
//  Table
//
//  Created by Konrad on 3/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import UIKit

// MARK: SeparatorView
open class SeparatorView: UIView { }

// MARK: Separatorable
public protocol Separatorable {
    var separatorInset: CGFloat { get }
}

public extension Separatorable {
    var separatorInset: CGFloat {
        return 8
    }
}

// MARK: Clickable
public protocol Clickable {
    var onClick: (() -> Void)? { get set }
}

// MARK: Focusable
public protocol Focusable {
    func focus()
    func focus(animated: Bool)
    func lostFocus()
    func lostFocus(animated: Bool)
}
public extension Focusable {
    func focus() {
        self.focus(animated: true)
    }
    
    func lostFocus() {
        self.lostFocus(animated: true)
    }
}

// MARK: Inputable
public protocol Inputable: Focusable { }

// MARK: Componentable
public protocol Componentable {
    func setupView()
    func setupActions()
    func setTheme()
    func setLanguage()
}

// MARK: FormsComponent
open class FormsComponent: UIView, Componentable {
    public weak var table: TableProtocol?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    public init() {
        super.init(frame: CGRect(width: 320, height: 44))
        self.setupView()
    }
    
    open func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupActions()
        self.setTheme()
        self.setLanguage()
    }
    
    open func enable(animated: Bool) {
        self.isUserInteractionEnabled = true
        let subviews: [UIView] = self.subviews.exclude { $0 is SeparatorView }
        for view in subviews {
            view.alpha = 1
        }
    }
    
    open func disable(animated: Bool) {
        self.isUserInteractionEnabled = true
        let subviews: [UIView] = self.subviews.exclude { $0 is Separatorable }
        for view in subviews {
            view.alpha = 0.3
        }
    }
    
    open func setSeparator(_ style: SeparatorStyle) {
        let subviews: [UIView] = self.subviews.filter { $0 is SeparatorView }
        subviews.removeFromSuperview()
        
        guard let separatorable = self as? Separatorable else {
            return
        }
        
        if style.contains(.top) {
            let topSeparator: SeparatorView = SeparatorView()
            self.addSubview(topSeparator, with: [
                Anchor.to(self).top,
                Anchor.to(self).horizontal.offset(separatorable.separatorInset)
            ])
        }
        
        if style.contains(.bottom) {
            let bottomSeparator: SeparatorView = SeparatorView()
            self.addSubview(bottomSeparator, with: [
                Anchor.to(self).top,
                Anchor.to(self).horizontal.offset(separatorable.separatorInset)
            ])
        }
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setTheme()
    }
    
    // MARK: HOOKS
    open func setupActions() {
        // HOOK
    }
    
    open func setTheme() {
        // HOOK
    }
    
    open func setLanguage() {
        // HOOK
    }
    
    open func componentHeight() -> CGFloat {
        // HOOK
        return UITableView.automaticDimension
    }
}

// MARK: Separator
public struct SeparatorStyle: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let top = SeparatorStyle(rawValue: 1 << 1)
    public static let bottom = SeparatorStyle(rawValue: 1 << 2)
}

// MARK: XibComponent
open class XibComponent: FormsComponent {
    override open func setupView() {
        let view: UIView = Bundle.main.instantiate(with: self)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        super.setupView()
    }
}

// MARK: Builder
public extension FormsComponent {
    func with(componentColor: UIColor?) -> Self {
        self.backgroundColor = componentColor
        return self
    }
}

// MARK: FormsComponentWithMarginEdgeInset
public protocol FormsComponentWithMarginEdgeInset: class {
    var marginEdgeInset: UIEdgeInsets { get set }
}
public extension FormsComponentWithMarginEdgeInset {
    func with(margin: CGFloat) -> Self {
        self.marginEdgeInset = UIEdgeInsets(margin)
        return self
    }
    func with(marginEdgeInset: UIEdgeInsets) -> Self {
        self.marginEdgeInset = marginEdgeInset
        return self
    }
    func with(marginHorizontal: CGFloat) -> Self {
        self.marginEdgeInset = UIEdgeInsets(horizontal: marginHorizontal)
        return self
    }
    func with(marginVertical: CGFloat) -> Self {
        self.marginEdgeInset = UIEdgeInsets(vertical: marginVertical)
        return self
    }
    func with(marginTop: CGFloat) -> Self {
        self.marginEdgeInset.top = marginTop
        return self
    }
    func with(marginBottom: CGFloat) -> Self {
        self.marginEdgeInset.bottom = marginBottom
        return self
    }
    func with(marginLeading: CGFloat) -> Self {
        self.marginEdgeInset.leading = marginLeading
        return self
    }
    func with(marginTrailing: CGFloat) -> Self {
        self.marginEdgeInset.trailing = marginTrailing
        return self
    }
}

// MARK: FormsComponentWithPaddingEdgeInset
public protocol FormsComponentWithPaddingEdgeInset: class {
    var paddingEdgeInset: UIEdgeInsets { get set }
}
public extension FormsComponentWithPaddingEdgeInset {
    func with(padding: CGFloat) -> Self {
        self.paddingEdgeInset = UIEdgeInsets(padding)
        return self
    }
    func with(paddingEdgeInset: UIEdgeInsets) -> Self {
        self.paddingEdgeInset = paddingEdgeInset
        return self
    }
    func with(paddingHorizontal: CGFloat) -> Self {
        self.paddingEdgeInset = UIEdgeInsets(horizontal: paddingHorizontal)
        return self
    }
    func with(paddingVertical: CGFloat) -> Self {
        self.paddingEdgeInset = UIEdgeInsets(vertical: paddingVertical)
        return self
    }
    func with(paddingTop: CGFloat) -> Self {
        self.paddingEdgeInset.top = paddingTop
        return self
    }
    func with(paddingBottom: CGFloat) -> Self {
        self.paddingEdgeInset.bottom = paddingBottom
        return self
    }
    func with(paddingLeading: CGFloat) -> Self {
        self.paddingEdgeInset.leading = paddingLeading
        return self
    }
    func with(paddingTrailing: CGFloat) -> Self {
        self.paddingEdgeInset.trailing = paddingTrailing
        return self
    }
}
