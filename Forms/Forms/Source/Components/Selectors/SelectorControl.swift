//
//  SelectorControl.swift
//  Forms
//
//  Created by Konrad on 8/21/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import UIKit

// MARK: State
public extension SelectorControl {
    struct State<T>: FormsComponentStateActiveSelectedDisabledDisabledSelected {
        public var active: T!
        public var selected: T!
        public var disabled: T!
        public var disabledSelected: T!
        
        public init() { }
    }
}

// MARK: ScrollDirection
public extension SelectorControl {
    enum SelectorDirection {
        case horizontal
        case vertical
        
        var scrollDirection: UICollectionView.ScrollDirection {
            switch self {
            case .horizontal: return .horizontal
            case .vertical: return .vertical
            }
        } 
    }
}

// MARK: SelectorItem
public protocol SelectorItem {
    var rawValue: Int { get }
    var title: String { get }
}

// MARK: SelectorControl
open class SelectorControl: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public let backgroundView = UIView()
        .with(width: 320, height: 40)
    public let arrowLeadingImageView = UIImageView()
        .with(contentMode: .center)
        .with(isUserInteractionEnabled: true)
        .with(width: 40, height: 40)
    public let gradientLeadingView = GradientView()
        .with(isUserInteractionEnabled: false)
    public lazy var collectionView = UICollectionView(
           frame: CGRect(width: 320, height: 40),
           collectionViewLayout: self.flowLayout)
    public let gradientTrailingView = GradientView()
        .with(isUserInteractionEnabled: false)
    public let arrowTrailingImageView = UIImageView()
        .with(contentMode: .center)
        .with(isUserInteractionEnabled: true)
        .with(width: 40, height: 40)
    
    private lazy var flowLayout = SelectorControlCollectionFlowLayout(
        scrollDirection: self.direction.scrollDirection)
    private let selectorUpdatesQueue: DispatchQueue = DispatchQueue(
        label: "selectorUpdatesQueue",
        target: DispatchQueue.main)
    private let defaultCellIdentifier: String = "_cell"
    
    open var animationTime: TimeInterval = 0.2
    open var arrowDistance: CGFloat = 8.0 {
        didSet { self.updateArrowDistance() }
    }
    open var arrowLeadingImage: LazyImage? = nil {
        didSet { self.updateArrowLeadingImage() }
    }
    open var arrowSize: CGFloat = 40.0 {
        didSet { self.updateDirection() }
    }
    open var arrowTrailingImage: LazyImage? = nil {
        didSet { self.updateArrowTrailingImage() }
    }
    open var backgroundColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryLight) {
        didSet { self.updateState() }
    }
    open var direction: SelectorDirection = .horizontal {
        didSet {
            self.flowLayout.scrollDirection = self.direction.scrollDirection
            self.updateDirection()
        }
    }
    open var isEnabled: Bool {
        get { return self.isUserInteractionEnabled }
        set { newValue ? self.enable(animated: false) : self.disable(animated: false) }
    }
    open var items: [SelectorItem] = [] {
        didSet { self.updateItems() }
    }
    open var itemSize: CGFloat = 24.0 {
        didSet { self.updateDirection() }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    private var _selected: SelectorItem? = nil {
        didSet { self.updateState(animated: false) }
    }
    open var selected: SelectorItem? {
        get { self._selected }
        set {
            self._selected = newValue
            self.scrollTo(item: newValue, animated: true)
        }
    }
    open var textColors: State<UIColor> = State<UIColor>(Theme.Colors.primaryDark) {
        didSet { self.updateState() }
    }
    open var textFonts: State<UIFont> = State<UIFont>(Theme.Fonts.regular(ofSize: 12)) {
        didSet { self.updateState() }
    }
    open var tintColors: State<UIColor?> = State<UIColor?>(Theme.Colors.primaryDark) {
        didSet { self.updateState() }
    }
    
    public var onValuePrev: ((SelectorItem) -> Void)? = nil
    public var onValueChanged: ((SelectorItem) -> Void)? = nil
    public var onValueNext: ((SelectorItem) -> Void)? = nil
    
    private (set) var state: FormsComponentStateType = .active
    
    private var canGoPrev: Bool {
        guard self.isEnabled else { return false }
        guard let index = self.items.firstIndex(where: { $0.rawValue == self.selected?.rawValue }) else { return false }
        return self.items.startIndex <= index.advanced(by: -1)
    }
    
    private var canGoNext: Bool {
        guard self.isEnabled else { return false }
        guard let index = self.items.firstIndex(where: { $0.rawValue == self.selected?.rawValue }) else { return false }
        return self.items.endIndex > index.advanced(by: 1)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.scrollTo(item: self._selected, animated: false, notify: false)
    }
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupArrowLeadingImageView()
        self.setupGradientLeadingView()
        self.setupCollectionView()
        self.setupGradientTrailingView()
        self.setupArrowTrailingImageView()
        self.updateDirection()
        super.setupView()
    }
    
    override open func setupActions() {
        super.setupActions()
        let leadingGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleOnArrowGesture))
        leadingGesture.minimumPressDuration = 0.0
        self.arrowLeadingImageView.addGestureRecognizer(leadingGesture)
        let trailingGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleOnArrowGesture))
        trailingGesture.minimumPressDuration = 0.0
        self.arrowTrailingImageView.addGestureRecognizer(trailingGesture)
    }
    
    @objc
    private func handleOnArrowGesture(recognizer: UIGestureRecognizer) {
        guard let imageView: UIImageView = recognizer.view as? UIImageView else { return }
        switch recognizer.state {
        case .began:
            if imageView == self.arrowLeadingImageView && self.canGoPrev ||
                imageView == self.arrowTrailingImageView && self.canGoNext {
                imageView.tintColor = self.tintColors.value(for: .selected)
            }
        case .ended:
            if imageView == self.arrowLeadingImageView && self.canGoPrev {
                self.scrollToPrev(animated: true)
            } else if imageView == self.arrowTrailingImageView && self.canGoNext {
                self.scrollToNext(animated: true)
            }
        case .cancelled:
            self.updateArrowTintColor()
        default: break
        }
    }
    
    override open func enable(animated: Bool) {
        self.isUserInteractionEnabled = true
        self.setState(.active, animated: animated)
    }
    
    override open func disable(animated: Bool) {
        self.isUserInteractionEnabled = false
        if !self.isEnabled {
            self.setState(.disabled, animated: animated)
        } else {
            self.setState(.active, animated: animated)
        }
    }
    
    open func setupBackgroundView() {
        self.backgroundView.frame = self.bounds
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    open func setupArrowLeadingImageView() {
        self.backgroundView.addSubview(self.arrowLeadingImageView, with: [])
    }
    
    open func setupGradientLeadingView() {
        self.backgroundView.addSubview(self.gradientLeadingView, with: [])
    }
    
    open func setupCollectionView() {
        self.collectionView.clipsToBounds = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.scrollsToTop = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.defaultCellIdentifier)
        self.backgroundView.addSubview(self.collectionView, with: [])
    }
    
    open func setupGradientTrailingView() {
        self.backgroundView.addSubview(self.gradientTrailingView, with: [])
    }
    
    open func setupArrowTrailingImageView() {
        self.backgroundView.addSubview(self.arrowTrailingImageView, with: [])
    }
    
    private func updateArrowDistance() {
        switch self.direction {
        case .horizontal:
            self.arrowLeadingImageView.constraint(to: self.collectionView, position: .trailingToLeading)?.constant = self.arrowDistance
            self.arrowTrailingImageView.constraint(to: self.collectionView, position: .leadingToTrailing)?.constant = self.arrowDistance
        case .vertical:
            self.arrowLeadingImageView.constraint(to: self.collectionView, position: .bottomToTop)?.constant = self.arrowDistance
            self.arrowTrailingImageView.constraint(to: self.collectionView, position: .topToBottom)?.constant = self.arrowDistance
        }
    }
    
    private func updateArrowLeadingImage() {
        if let image: UIImage = self.arrowLeadingImage?() {
            self.arrowLeadingImageView.image = image
        } else {
            switch self.direction {
            case .horizontal: self.arrowLeadingImageView.image = UIImage.from(name: "chevron.left")
            case .vertical: self.arrowLeadingImageView.image = UIImage.from(name: "chevron.up")
            }
        }
    }
    
    private func updateArrowTrailingImage() {
        if let image: UIImage = self.arrowTrailingImage?() {
            self.arrowTrailingImageView.image = image
        } else {
            switch self.direction {
            case .horizontal: self.arrowTrailingImageView.image = UIImage.from(name: "chevron.right")
            case .vertical: self.arrowTrailingImageView.image = UIImage.from(name: "chevron.down")
            }
        }
    }
    
    private func updateDirection() {
        [self.arrowLeadingImageView, self.arrowTrailingImageView, self.collectionView, self.gradientLeadingView, self.gradientLeadingView]
            .forEach {
                $0.removeFromSuperview()
                $0.constraint(position: .height)?.isActive = false
                $0.constraint(position: .width)?.isActive = false
        }
        
        switch self.direction {
        case .horizontal:
            self.backgroundView.addSubview(self.arrowLeadingImageView, with: [
                Anchor.to(self.backgroundView).vertical,
                Anchor.to(self.backgroundView).leading,
                Anchor.to(self.arrowLeadingImageView).width(self.arrowSize)
            ])
            self.backgroundView.addSubview(self.collectionView, with: [
                Anchor.to(self.arrowLeadingImageView).leadingToTrailing.offset(self.arrowDistance),
                Anchor.to(self.backgroundView).vertical,
                Anchor.to(self.collectionView).height(self.itemSize)
            ])
            self.backgroundView.addSubview(self.arrowTrailingImageView, with: [
                Anchor.to(self.collectionView).leadingToTrailing.offset(self.arrowDistance),
                Anchor.to(self.backgroundView).vertical,
                Anchor.to(self.backgroundView).trailing,
                Anchor.to(self.arrowTrailingImageView).width(self.arrowSize)
            ])
            self.gradientLeadingView.style = .linearHorizontal
            self.backgroundView.addSubview(self.gradientLeadingView, with: [
                Anchor.to(self.collectionView).vertical,
                Anchor.to(self.collectionView).leading,
                Anchor.to(self.collectionView).width.multiplier(1.0 / 4.0)
            ])
            self.gradientTrailingView.style = .linearHorizontal
            self.backgroundView.addSubview(self.gradientTrailingView, with: [
                Anchor.to(self.collectionView).vertical,
                Anchor.to(self.collectionView).trailing,
                Anchor.to(self.collectionView).width.multiplier(1.0 / 4.0)
            ])
        case .vertical:
            self.backgroundView.addSubview(self.arrowLeadingImageView, with: [
                Anchor.to(self.backgroundView).horizontal,
                Anchor.to(self.backgroundView).top,
                Anchor.to(self.arrowLeadingImageView).height(self.arrowSize)
            ])
            self.backgroundView.addSubview(self.collectionView, with: [
                Anchor.to(self.arrowLeadingImageView).topToBottom.offset(self.arrowDistance),
                Anchor.to(self.backgroundView).horizontal,
                Anchor.to(self.collectionView).height(self.itemSize * 2)
            ])
            self.backgroundView.addSubview(self.arrowTrailingImageView, with: [
                Anchor.to(self.collectionView).topToBottom.offset(self.arrowDistance),
                Anchor.to(self.backgroundView).horizontal,
                Anchor.to(self.backgroundView).bottom,
                Anchor.to(self.arrowTrailingImageView).height(self.arrowSize)
            ])
            self.gradientLeadingView.style = .linearVertical
            self.backgroundView.addSubview(self.gradientLeadingView, with: [
                Anchor.to(self.collectionView).horizontal,
                Anchor.to(self.collectionView).top,
                Anchor.to(self.collectionView).height.multiplier(1.0 / 3.0)
            ])
            self.gradientTrailingView.style = .linearVertical
            self.backgroundView.addSubview(self.gradientTrailingView, with: [
                Anchor.to(self.collectionView).horizontal,
                Anchor.to(self.collectionView).bottom,
                Anchor.to(self.collectionView).height.multiplier(1.0 / 3.0)
            ])
        }
        self.updateArrowDistance()
        self.updatePaddingEdgeInset()
        self.updateArrowLeadingImage()
        self.updateArrowTrailingImage()
    }
    
    private func updateItems() {
        if self._selected.isNil {
            self._selected = self.items.first
        }
        self.reloadData()
    }
    
    private func reloadData() {
        self.selectorUpdatesQueue.async {
            self.collectionView.reloadData()
        }
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
        switch self.direction {
        case .horizontal:
            self.arrowLeadingImageView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
            self.collectionView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
            self.collectionView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
            self.arrowTrailingImageView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        case .vertical:
            self.arrowLeadingImageView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
            self.collectionView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
            self.collectionView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
            self.arrowTrailingImageView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        }
    }
    
    open func updateArrowTintColor() {
        self.arrowLeadingImageView.tintColor = self.canGoPrev
            ? self.tintColors.value(for: .active)
            : self.tintColors.value(for: .disabled)
        self.arrowTrailingImageView.tintColor = self.canGoNext
            ? self.tintColors.value(for: .active)
            : self.tintColors.value(for: .disabled)
    }
    
    public func updateState(animated: Bool) {
        if !self.isEnabled {
            self.setState(.disabled, animated: animated)
        } else if self.selected.isNotNil {
            self.setState(.selected, animated: animated)
        } else {
            self.setState(.active, animated: animated)
        }
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
        self.gradientLeadingView.gradientColors = [
            self.backgroundColors.value(for: state),
            self.backgroundColors.value(for: state)?.with(alpha: 0.0)
        ]
        self.collectionView.backgroundColor = self.backgroundColors.value(for: state)
        self.gradientTrailingView.gradientColors = [
            self.backgroundColors.value(for: state)?.with(alpha: 0.0),
            self.backgroundColors.value(for: state)
        ]
        self.updateArrowTintColor()
        self.reloadData()
    }
}

// MARK: Scroll
public extension SelectorControl {
    func scrollToPrev(animated: Bool,
                      notify: Bool = true) {
        guard let selected: SelectorItem = self._selected ?? self.items.first else { return }
        guard let index = self.items.firstIndex(where: { $0.rawValue == selected.rawValue }) else { return }
        let prevIndex = index.advanced(by: -1)
        guard self.items.startIndex <= prevIndex else { return }
        guard let item: SelectorItem = self.items[safe: prevIndex] else { return }
        self.scrollTo(item: item, animated: animated, notify: notify)
        if notify {
            self.onValuePrev?(item)
        }
    }
    
    func scrollToNext(animated: Bool,
                      notify: Bool = true) {
        guard let selected: SelectorItem = self._selected ?? self.items.first else { return }
        guard let index = self.items.firstIndex(where: { $0.rawValue == selected.rawValue }) else { return }
        let nextIndex = index.advanced(by: 1)
        guard nextIndex < self.items.endIndex else { return }
        guard let item: SelectorItem = self.items[safe: nextIndex] else { return }
        self.scrollTo(item: item, animated: animated, notify: notify)
        if notify {
            self.onValueNext?(item)
        }
    }
    
    func scrollTo(item: SelectorItem?,
                  animated: Bool,
                  notify: Bool = true) {
        guard let item: SelectorItem = item else { return }
        self._selected = item
        self.updateArrowTintColor()
        self.reloadVisibleCells()
        self.selectorUpdatesQueue.async {
            guard let offset: CGPoint = self.offsetForItem(item) else { return }
            guard self.collectionView.contentOffset != offset else { return }
            self.collectionView.setContentOffset(offset, animated: animated)
        }
        if notify {
            self.onValueChanged?(item)
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension SelectorControl: UICollectionViewDelegate, UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: self.defaultCellIdentifier, for: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let contentView: UIView = cell.subviews.first else { return }
        let item: SelectorItem = self.items[indexPath.row]
        let state: FormsComponentStateType = self.stateForItem(item)
        let label: UILabel = (contentView.subviews[safe: 0] as? UILabel) ?? UILabel()
        label.tag = indexPath.row
        label.text = self.items[indexPath.row].title
        label.textColor = self.textColors.value(for: state)
        label.textAlignment = .center
        label.font = self.textFonts.value(for: state)
        guard label.superview.isNil else { return }
        contentView.addSubview(label, with: [
            Anchor.to(contentView).fill
        ])
    }
     
    private func stateForItem(_ item: SelectorItem) -> FormsComponentStateType {
        let isSelected: Bool = item.rawValue == self._selected?.rawValue
        if !self.isEnabled && !isSelected {
            return .disabled
        } else if !self.isEnabled && isSelected {
            return .disabledSelected
        } else if isSelected {
            return .selected
        } else {
            return .active
        }
    }
    
    private func reloadVisibleCells() {
        self.collectionView.visibleCells
            .map { $0.contentView.subviews[safe: 0] }
            .compactMap { $0 as? UILabel }
            .forEach { (label) in
                guard let item: SelectorItem = self.items[safe: label.tag] else { return }
                let state: FormsComponentStateType = self.stateForItem(item)
                label.textColor = self.textColors.value(for: state)
                label.font = self.textFonts.value(for: state)
            }
    }
}

// MARK: UIScrollViewDelegate
extension SelectorControl {
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let item: SelectorItem = self.itemForOffset(targetContentOffset.pointee) else { return }
        scrollView.targetContentOffset = self.offsetForItem(item)
    }
     
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let item: SelectorItem = self.itemForOffset(scrollView.targetContentOffset) else { return }
        self.scrollTo(item: item, animated: true)
    }
    
    private func itemForOffset(_ offset: CGPoint) -> SelectorItem? {
        guard let layout = self.collectionView.collectionViewLayout as? SelectorControlCollectionFlowLayout else { return nil }
        guard let index: Int = layout.itemForOffset(offset)?.match(in: 0..<(self.items.count - 1)) else { return nil }
        return self.items[safe: index]
    }
    
    private func offsetForItem(_ item: SelectorItem) -> CGPoint? {
        guard let layout = self.collectionView.collectionViewLayout as? SelectorControlCollectionFlowLayout else { return nil }
        guard let index = self.items.firstIndex(where: { $0.rawValue == item.rawValue }) else { return nil }
        return layout.offsetForIndex(index)
    }
}

// MARK: SelectorControlCollectionFlowLayout
open class SelectorControlCollectionFlowLayout: UICollectionViewFlowLayout {
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentSize: CGSize = CGSize()
    
    override open var scrollDirection: UICollectionView.ScrollDirection {
        get { return super.scrollDirection }
        set {
            super.scrollDirection = newValue
            self.invalidateLayout()
        }
    }
    
    public var itemWidth: CGFloat {
        guard let frame: CGRect = self.collectionView?.frame else { return 0.0 }
        switch self.scrollDirection {
        case .vertical: return frame.width
        case .horizontal: return frame.width / 2
        @unknown default: return 0.0
        }
    }
    
    public var itemHeight: CGFloat {
        guard let frame: CGRect = self.collectionView?.frame else { return 0.0 }
        switch self.scrollDirection {
        case .vertical: return frame.height / 2
        case .horizontal: return frame.height
        @unknown default: return 0.0
        }
    }
    
    public init(scrollDirection: UICollectionView.ScrollDirection) {
        super.init()
        self.scrollDirection = scrollDirection
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.scrollDirection = .horizontal
    }
    
    override public var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard self.collectionView?.bounds.size != newBounds.size else { return false }
        self.cache = []
        return true
    }
    
    override public func prepare() {
        self.itemSize = CGSize(width: 320, height: 40)
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        super.prepare()
        guard self.cache.isEmpty else { return }
        guard let collectionView = self.collectionView else { return }
        switch self.scrollDirection {
        case .vertical: self.prepareVertical(collectionView: collectionView)
        case .horizontal: self.prepareHorizontal(collectionView: collectionView)
        @unknown default: break
        }
    }
    
    private func prepareVertical(collectionView: UICollectionView) {
        let width: CGFloat = self.itemWidth
        let height: CGFloat = self.itemHeight
        let contentInset: UIEdgeInsets = UIEdgeInsets(vertical: height / 2, horizontal: 0)
        let offsetsX: CGFloat = contentInset.leading
        var offsetsY: CGFloat = contentInset.top
        let itemsCount: Int = collectionView.numberOfItems(inSection: 0)
        for item in 0 ..< itemsCount {
            let indexPath = IndexPath(item: item, section: 0)
            let frame: CGRect = CGRect(x: offsetsX, y: offsetsY, width: width, height: height)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            self.cache.append(attributes)
            offsetsY += height
        }
        self.contentSize = CGSize(
            width: collectionView.frame.width,
            height: offsetsY + contentInset.bottom)
    }
    
    private func prepareHorizontal(collectionView: UICollectionView) {
        let height: CGFloat = self.itemHeight
        let width: CGFloat = self.itemWidth
        let contentInset: UIEdgeInsets = UIEdgeInsets(vertical: 0, horizontal: width / 2)
        var offsetsX: CGFloat = contentInset.leading
        let offsetsY: CGFloat = contentInset.top
        let itemsCount: Int = collectionView.numberOfItems(inSection: 0)
        for item in 0 ..< itemsCount {
            let indexPath = IndexPath(item: item, section: 0)
            let frame: CGRect = CGRect(x: offsetsX, y: offsetsY, width: width, height: height)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            self.cache.append(attributes)
            offsetsX += width
        }
        self.contentSize = CGSize(
            width: offsetsX + contentInset.trailing,
            height: collectionView.frame.height)
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in self.cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    public func itemForOffset(_ offset: CGPoint) -> Int? {
        switch self.scrollDirection {
        case .vertical:
            return Int(round(offset.y / self.itemHeight))
        case .horizontal:
            return Int(round(offset.x / self.itemWidth))
        @unknown default: return nil
        }
    }
    
    public func offsetForIndex(_ index: Int) -> CGPoint? {
        switch self.scrollDirection {
        case .vertical:
            guard let collectionHeight: CGFloat = self.collectionView?.frame.height else { return nil }
            guard let point: CGPoint = self.cache[safe: index]?.frame.origin else { return nil }
            return CGPoint(
                x: point.x,
                y: point.y - collectionHeight / 4)
        case .horizontal:
            guard let collectionWidth: CGFloat = self.collectionView?.frame.width else { return nil }
            guard let point: CGPoint = self.cache[safe: index]?.frame.origin else { return nil }
            return CGPoint(
                x: point.x - collectionWidth / 4,
                y: point.y)
        @unknown default: return nil
        }
    }
}

// MARK: Builder
public extension SelectorControl {
    func with(animationTime: TimeInterval) -> Self {
        self.animationTime = animationTime
        return self
    }
    func with(arrowDistance: CGFloat) -> Self {
        self.arrowDistance = arrowDistance
        return self
    }
    func with(arrowLeadingImage: LazyImage?) -> Self {
        self.arrowLeadingImage = arrowLeadingImage
        return self
    }
    func with(arrowSize: CGFloat) -> Self {
        self.arrowSize = arrowSize
        return self
    }
    func with(arrowTrailingImage: LazyImage?) -> Self {
        self.arrowTrailingImage = arrowTrailingImage
        return self
    }
    @objc
    override func with(backgroundColor: UIColor?) -> Self {
        self.backgroundColors = State<UIColor?>(backgroundColor)
        return self
    }
    func with(backgroundColors: State<UIColor?>) -> Self {
        self.backgroundColors = backgroundColors
        return self
    }
    func with(direction: SelectorDirection) -> Self {
        self.direction = direction
        return self
    }
    func with(isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }
    func with(items: [SelectorItem]) -> Self {
        self.items = items
        return self
    }
    func with(itemSize: CGFloat) -> Self {
        self.itemSize = itemSize
        return self
    }
    func with(selected: SelectorItem?) -> Self {
        self.selected = selected
        return self
    }
    func with(textColor: UIColor) -> Self {
        self.textColors = State<UIColor>(textColor)
        return self
    }
    func with(textColors: State<UIColor>) -> Self {
        self.textColors = textColors
        return self
    }
    func with(textFont: UIFont) -> Self {
        self.textFonts = State<UIFont>(textFont)
        return self
    }
    func with(textFonts: State<UIFont>) -> Self {
        self.textFonts = textFonts
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
