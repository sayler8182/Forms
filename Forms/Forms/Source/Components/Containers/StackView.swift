//
//  StackView.swift
//  Forms
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import UIKit

// MARK: StackView
open class StackView: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
    public let stackView = UIStackView()
    
    open var alignment: UIStackView.Alignment {
        get { return self.stackView.alignment }
        set { self.stackView.alignment = newValue }
    }
    open var axis: NSLayoutConstraint.Axis {
        get { return self.stackView.axis }
        set { self.stackView.axis = newValue }
    }
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    open var distribution: UIStackView.Distribution {
        get { return self.stackView.distribution }
        set { self.stackView.distribution = newValue }
    }
    open var height: CGFloat = UITableView.automaticDimension
    private var _items: [UIView] = []
    open var items: [UIView] {
        get { return self._items }
        set {
            self._items = newValue
            self.remakeView()
        }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var spacing: CGFloat {
        get { return self.stackView.spacing }
        set { self.stackView.spacing = newValue }
    }
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupStackView()
        super.setupView()
    }
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
    
    open func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    open func setupStackView() {
        self.stackView.alignment = UIStackView.Alignment.fill
        self.stackView.axis = NSLayoutConstraint.Axis.horizontal
        self.stackView.distribution = UIStackView.Distribution.fillEqually
        self.stackView.spacing = 0
        self.backgroundView.addSubview(self.stackView, with: [
            Anchor.to(self.backgroundView).fill
        ])
    }
    
    open func updateMarginEdgeInset() {
        let edgeInset: UIEdgeInsets = self.marginEdgeInset
        self.backgroundView.frame = self.bounds.with(inset: edgeInset)
        self.backgroundView.constraint(to: self, position: .top)?.constant = edgeInset.top
        self.backgroundView.constraint(to: self, position: .bottom)?.constant = -edgeInset.bottom
        self.backgroundView.constraint(to: self, position: .leading)?.constant = edgeInset.leading
        self.backgroundView.constraint(to: self, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    open func updatePaddingEdgeInset() {
        let edgeInset: UIEdgeInsets = self.paddingEdgeInset
        self.stackView.frame = self.bounds.with(inset: edgeInset)
        self.stackView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.stackView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.stackView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.stackView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
}

// MARK: UIView
private extension StackView {
    func remakeView() {
        self.items.forEach { $0.layoutIfNeeded() }
        self.stackView.removeArrangedSubviews()
        self.stackView.addArrangedSubviews(self.items)
    }
}

// MARK: UIView
public extension StackView {
    func setItems(_ items: [UIView],
                  layout: Bool = false) {
        defer { self.items = items }
        guard layout else { return }
        self.withoutAnimation {
            for (i, item) in items.enumerated() {
                self.layoutIfNeeded(view: item, after: items[safe: i - 1])
            }
        }
    }
    
    func removeItems() {
        self._items = []
        self.stackView.removeArrangedSubviews()
    }
    
    func removeItems(_ items: [UIView]) {
        self._items = self.items.filter { !items.contains($0) }
        self.stackView.removeArrangedSubviews(items)
    }
    
    func addItems(_ items: [UIView]) {
        self._items.append(contentsOf: items)
        self.stackView.addArrangedSubviews(items)
    }
    
    func layoutIfAnimated(animated: Bool, view: UIView, after: UIView? = nil) {
        guard animated else { return }
        self.layoutIfNeeded(view: view, after: after)
    }
    
    func layoutIfNeeded(view: UIView, after: UIView? = nil) {
        switch self.axis {
        case .vertical:
            let y: CGFloat = after != nil ? after!.frame.origin.y + after!.frame.height + self.spacing : 0 // swiftlint:disable:this force_unwrapping
            view.layoutIfNeeded()
            view.frame = CGRect(
                origin: CGPoint(x: 0, y: y),
                size: CGSize(width: self.frame.width, height: view.frame.height))
            guard view.superview.isNil else { return }
            let superview = UIView(frame: view.frame)
            superview.anchors([
                Anchor.to(superview).height(superview.frame.height),
                Anchor.to(superview).width(superview.frame.width)
            ])
            superview.addSubview(view, with: [
                Anchor.to(superview).fill
            ])
            superview.layoutIfNeeded()
            view.removeFromSuperview()
            view.frame.origin.y = superview.frame.origin.y
        case .horizontal: break
        @unknown default: break
        }
    }
}

// MARK: Builder
public extension StackView {
    func with(alignment: UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }
    func with(axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
        return self
    }
    func with(distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(items: [UIView]) -> Self {
        self.items = items
        return self
    }
    func with(spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }
}
