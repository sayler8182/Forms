//
//  GridView.swift
//  Forms
//
//  Created by Konrad on 8/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsUtilsUI
import UIKit

// MARK: GridView
open class GridView: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
    public let stackView = UIStackView()
    
    open var axis: NSLayoutConstraint.Axis {
        get { return self.stackView.axis }
        set {
            self.stackView.axis = newValue
            self.remakeView()
        }
    }
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    open var height: CGFloat = UITableView.automaticDimension
    open var items: [UIView] = [] {
        didSet { self.remakeView() }
    }
    open var itemsPerSection: Int = 0 {
        didSet { self.remakeView() }
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
    
    public var sectionsCount: Int {
        return self.stackView.arrangedSubviews.count
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
        self.stackView.axis = NSLayoutConstraint.Axis.vertical
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

// MARK: View
public extension GridView {
    func remakeView() {
        self.stackView.removeArrangedSubviews()
        guard 0 < self.itemsPerSection else { return }
        let sections: Int = (self.items.count.asCGFloat / self.itemsPerSection.asCGFloat).ceiled.asInt
        for section in 0..<sections {
            let view: UIStackView = UIStackView()
            view.alignment = UIStackView.Alignment.fill
            view.axis = self.axis.reversed
            view.distribution = UIStackView.Distribution.fillEqually
            for j in 0..<self.itemsPerSection {
                let i: Int = (section * self.itemsPerSection) + j
                guard let item: UIView = self.items[safe: i] else { break }
                view.addArrangedSubview(item)
            }
            self.stackView.addArrangedSubview(view)
        }
    }
}

// MARK: Builder
public extension GridView {
    func with(axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
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
    func with(itemsPerSection: Int) -> Self {
        self.itemsPerSection = itemsPerSection
        return self
    }
    func with(spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }
}
