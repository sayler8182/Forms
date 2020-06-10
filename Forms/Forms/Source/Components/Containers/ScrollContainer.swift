//
//  ScrollContainer.swift
//  Forms
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsUtils
import UIKit

// MARK: ScrollDirection
public extension ScrollContainer {
    enum ScrollDirection {
        case horizontal
        case vertical
        
        var axis: NSLayoutConstraint.Axis {
            switch self {
            case .horizontal: return .horizontal
            case .vertical: return .vertical
            }
        }
    }
}

// MARK: ScrollContainer
open class ScrollContainer: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public typealias OnDidScroll = ((_ scrollView: UIScrollView) -> Void)
    
    private let backgroundView = UIView()
    private let scrollView = UIScrollView(frame: CGRect.zero)
    private let stackView = UIStackView()
    
    private var items: [FormsComponent] = []
    
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    open var bounces: Bool {
        get { return self.scrollView.bounces }
        set { self.scrollView.bounces = newValue }
    }
    open var height: CGFloat = UITableView.automaticDimension
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var scrollDelegate: UIScrollViewDelegate? {
        get { return self.scrollView.delegate }
        set { self.scrollView.delegate = newValue }
    }
    open var scrollDirection: ScrollDirection = .horizontal {
        didSet { self.updateScrollDirection() }
    }
    open var scrollSteps: ScrollSteps?
    open var showsHorizontalScrollIndicator: Bool {
        get { return self.scrollView.showsHorizontalScrollIndicator }
        set { self.scrollView.showsHorizontalScrollIndicator = newValue }
    }
    open var showsVerticalScrollIndicator: Bool {
        get { return self.scrollView.showsVerticalScrollIndicator }
        set { self.scrollView.showsVerticalScrollIndicator = newValue }
    }
    open var spacing: CGFloat {
        get { return self.stackView.spacing }
        set { self.stackView.spacing = newValue }
    }
    
    public var onDidScroll: OnDidScroll? = nil
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupScrollView()
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
    
    private func setupScrollView() {
        self.scrollView.backgroundColor = UIColor.clear
        self.scrollView.delegate = self
        self.scrollView.frame = self.backgroundView.bounds
        self.scrollView.clipsToBounds = true
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        }
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.backgroundView.addSubview(self.scrollView, with: [
            Anchor.to(self.backgroundView).fill
        ])
    }
    
    private func setupStackView() {
        self.stackView.alignment = UIStackView.Alignment.fill
        self.stackView.distribution = UIStackView.Distribution.equalSpacing
        self.scrollView.addSubview(self.stackView, with: [
            Anchor.to(self.scrollView).fill
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
        self.stackView.constraint(to: self.scrollView, position: .top)?.constant = edgeInset.top
        self.stackView.constraint(to: self.scrollView, position: .bottom)?.constant = -edgeInset.bottom
        self.stackView.constraint(to: self.scrollView, position: .leading)?.constant = edgeInset.leading
        self.stackView.constraint(to: self.scrollView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    private func updateScrollDirection() {
        self.stackView.axis = self.scrollDirection.axis
    }
     
    public func setItems(_ items: [FormsComponent]) {
        self.items = items
        self.stackView.addArrangedSubviews(items)
    }
}

// MARK: UIScrollViewDelegate
extension ScrollContainer: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollSteps?.update(scrollView.contentOffset)
        self.onDidScroll?(scrollView)
    }
}
    
// MARK: Builder
public extension ScrollContainer {
    func with(bounces: Bool) -> Self {
        self.bounces = bounces
        return self
    }
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(items: [FormsComponent]) -> Self {
        self.setItems(items)
        return self
    }
    func with(onDidScroll: @escaping OnDidScroll) -> Self {
        self.onDidScroll = onDidScroll
        return self
    }
    func with(scrollDelegate: UIScrollViewDelegate?) -> Self {
        self.scrollDelegate = scrollDelegate
        return self
    }
    func with(scrollDirection: ScrollDirection) -> Self {
        self.scrollDirection = scrollDirection
        return self
    }
    func with(scrollSteps: ScrollSteps) -> Self {
        self.scrollSteps = scrollSteps
        return self
    }
    func with(showsHorizontalScrollIndicator: Bool) -> Self {
        self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        return self
    }
    func with(showsVerticalScrollIndicator: Bool) -> Self {
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        return self
    }
    func with(spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }
}
