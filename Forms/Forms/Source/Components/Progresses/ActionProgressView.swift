//
//  ActionProgressView.swift
//  Forms
//
//  Created by Konrad on 9/7/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import UIKit

// MARK: State
public extension ActionProgressView {
    struct State<T>: FormsComponentStateActiveSelectedDisabled {
        public var active: T!
        public var selected: T!
        public var disabled: T!
        
        public init() { }
    }
}

// MARK: ActionProgressItem
public struct ActionProgressItem: Equatable {
    let key: String
    let icon: LazyImage?
    let selectedIcon: LazyImage?
    
    public init(key: String? = nil,
                icon: LazyImage?) {
        self.init(
            key: key,
            icon: icon,
            selectedIcon: icon)
    }
    
    public init(key: String? = nil,
                icon: LazyImage?,
                selectedIcon: LazyImage?) {
        self.key = key ?? UUID().uuidString
        self.icon = icon
        self.selectedIcon = selectedIcon
    }
    
    public static var empty: UIImage? {
        return UIImage(
            color: UIColor.white,
            size: CGSize(size: 5))?
            .circled()
    }
    
    public static var separator: UIImage? {
        return UIImage(
            color: UIColor.white,
            size: CGSize(width: 5, height: 1))?
            .rounded(radius: 1)
    }
    
    public static func == (lhs: ActionProgressItem, rhs: ActionProgressItem) -> Bool {
        return lhs.key == rhs.key
    }
}

// MARK: ActionProgressView
open class ActionProgressView: FormsComponent, FormsComponentWithProgress, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
        .with(isUserInteractionEnabled: true)
    public let contentView = UIView()
    
    public let gestureRecognizer = UITapGestureRecognizer()
    
    open var animationTime: TimeInterval = 0.2
    open var backgroundColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryLight) {
        didSet { self.updateState() }
    }
    open var height: CGFloat = UITableView.automaticDimension
    open var isEnabled: Bool = true
    open var items: [ActionProgressItem] = [] {
        didSet { self.remakeContentView() }
    }
    open var itemSize: CGFloat = 36.0 {
        didSet { self.remakeContentView() }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var progress: CGFloat = 0 {
        didSet { self.setProgress(self.progress, animated: false) }
    }
    private var _selected: ActionProgressItem? = nil
    open var selected: ActionProgressItem? {
        get { self._selected }
        set {
            self._selected = newValue
            self.updateContentView()
        }
    }
    open var separatorView: LazyView? = nil {
        didSet { self.remakeContentView() }
    }
    open var tintColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryDark) {
        didSet { self.updateState() }
    }
    
    public var onClick: (() -> Void)? = nil
    
    private (set) var state: FormsComponentStateType = .active
    
    override public func setupView() {
        self.setupBackgroundView()
        self.setupContentView()
        super.setupView()
    }
    
    override open func setTheme() {
        super.setTheme()
        self.updateContentView()
    }
    
    override open func enable(animated: Bool) {
        if !self.isEnabled {
            self.isEnabled = true
        }
        self.setState(.active, animated: animated)
    }
    
    override open func disable(animated: Bool) {
        if self.isEnabled {
            self.isEnabled = false
        }
        self.setState(.disabled, animated: animated)
    }
    
    override open func componentHeight() -> CGFloat {
        return self.height
    }
    
    override open func setupActions() {
        super.setupActions()
        self.gestureRecognizer.addTarget(self, action: #selector(handleGesture))
        self.backgroundView.addGestureRecognizer(self.gestureRecognizer)
    }
    
    @objc
    private func handleGesture(recognizer: UITapGestureRecognizer) {
        guard self.isEnabled else { return }
        self.onClick?()
    }
    
    open func setProgress(_ progress: CGFloat,
                          animated: Bool) {
        let progress: CGFloat = progress.match(in: 0..<1)
        let index: Int = (progress * self.items.count.advanced(by: -1).asCGFloat).rounded().asInt
        self.selected = self.items[safe: index]
    }
    
    open func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    open func setupContentView() {
        self.contentView.frame = self.bounds
        self.backgroundView.addSubview(self.contentView, with: [
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
        self.contentView.frame = self.bounds.with(inset: edgeInset)
        self.contentView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.contentView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.contentView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.contentView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    override public func updateState() {
        guard !self.isBatchUpdateInProgress else { return }
        self.setState(self.state, animated: false, force: true)
    }
    
    public func setState(_ state: FormsComponentStateType,
                         animated: Bool,
                         force: Bool = false) {
        guard self.state != state || force else { return }
        self.animation(animated, duration: self.animationTime) {
            self.setStateAnimation(state)
        }
        self.state = state
    }
    
    open func setStateAnimation(_ state: FormsComponentStateType) {
        self.backgroundView.backgroundColor = self.backgroundColors.value(for: state)
        self.updateContentView()
    }
}

// MARK: View
public extension ActionProgressView {
    func remakeContentView() {
        guard !self.isBatchUpdateInProgress else { return }
        self.contentView.removeSubviews()
        let view: GridView = GridView()
        view.batchUpdate({
            view.axis = .vertical
            view.items = self.images()
            view.itemsPerSection = Int.max
        }, view.remakeView)
        let sectionsCount: Int = view.sectionsCount
        self.contentView.addSubview(view, with: [
            Anchor.to(self.contentView).fill,
            Anchor.to(self.contentView).height(self.itemSize * sectionsCount.asCGFloat)
        ])
    }
    
    private func updateContentView() {
        guard let gridView: GridView = self.contentView.subviews[safe: 0] as? GridView else { return }
        for view in gridView.items {
            self.updateItemView(view: view)
        }
    }
    
    private func images() -> [UIView] {
        var views: [UIView] = self.items
            .enumerated()
            .map { self.itemView($0, $1) }
        views = views.separated(by: self.separatorView)
        return views
    }
    
    private func itemView(_ index: Int,
                          _ item: ActionProgressItem) -> UIView {
        let view: UIImageView = UIImageView()
        view.tag = index + 1
        view.contentMode = .center
        self.updateItemView(view: view)
        return view
    }
    
    private func itemState(index: Int) -> FormsComponentStateType {
        guard self.isEnabled else { return .disabled }
        guard let item: ActionProgressItem = self.items[safe: index] else { return .active }
        return item == self._selected
            ? .selected
            : .active
    }
    
    private func updateItemView(view: UIView) {
        guard view.tag != 0 else { return }
        let imageView: UIImageView? = view as? UIImageView
        let index: Int = view.tag - 1
        let state: FormsComponentStateType = self.itemState(index: index)
        imageView?.tintColor = self.tintColors.value(for: state)
        imageView?.image = state != .selected
            ? self.items[safe: index]?.icon?()?.asTemplate
            : self.items[safe: index]?.selectedIcon?()?.asTemplate
    }
}

// MARK: Builder
public extension ActionProgressView {
    @objc
    override func with(backgroundColor: UIColor?) -> Self {
        self.backgroundColors = State<UIColor?>(backgroundColor)
        return self
    }
    func with(backgroundColors: State<UIColor?>) -> Self {
        self.backgroundColors = backgroundColors
        return self
    }
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(items: [ActionProgressItem]) -> Self {
        self.items = items
        return self
    }
    func with(itemSize: CGFloat) -> Self {
        self.itemSize = itemSize
        return self
    }
    func with(separatorView: LazyView?) -> Self {
        self.separatorView = separatorView
        return self
    }
    func with(tintColor: UIColor?) -> Self {
        self.tintColors = State<UIColor?>(tintColor)
        return self
    }
    func with(tintColors: State<UIColor?>) -> Self {
        self.tintColors = tintColors
        return self
    }
}
