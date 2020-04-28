//
//  StackContainer.swift
//  Forms
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: StackContainer
open class StackContainer: FormComponent, FormComponentWithMarginEdgeInset, FormComponentWithPaddingEdgeInset {
    private let backgroundView = UIView()
    private let stackView = UIStackView()
    
    private var items: [FormComponent] = []
    
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
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var height: CGFloat = UITableView.automaticDimension
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
     
    override open func setupView() {
        self.setupBackgroundView()
        self.setupStackView()
        super.setupView()
    }
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
    
    private func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    private func setupStackView() {
        self.stackView.alignment = UIStackView.Alignment.fill
        self.stackView.axis = NSLayoutConstraint.Axis.horizontal
        self.stackView.distribution = UIStackView.Distribution.fillEqually
        self.backgroundView.addSubview(self.stackView, with: [
            Anchor.to(self.backgroundView).fill
        ])
    }
    
    private func updateMarginEdgeInset() {
        let edgeInset: UIEdgeInsets = self.marginEdgeInset
        self.backgroundView.frame = self.bounds.with(inset: edgeInset)
        self.backgroundView.constraint(to: self, position: .top)?.constant = edgeInset.top
        self.backgroundView.constraint(to: self, position: .bottom)?.constant = -edgeInset.bottom
        self.backgroundView.constraint(to: self, position: .leading)?.constant = edgeInset.leading
        self.backgroundView.constraint(to: self, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    private func updatePaddingEdgeInset() {
        let edgeInset: UIEdgeInsets = self.paddingEdgeInset
        self.stackView.frame = self.bounds.with(inset: edgeInset)
        self.stackView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.stackView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.stackView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.stackView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    public func setItems(_ items: [FormComponent]) {
        self.items = items
        self.stackView.removeArrangedSubviews()
        self.stackView.addArrangedSubviews(items)
    }
}
 
// MARK: Builder
public extension StackContainer {
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
    func with(items: [FormComponent]) -> Self {
        self.setItems(items)
        return self
    }
}
