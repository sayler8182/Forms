//
//  TopBar.swift
//  Forms
//
//  Created by Konrad on 4/6/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import UIKit

// MARK: TopBarItem
public protocol TopBarItemProtocol {
    var index: Int { get }
    var title: String? { get }
}

open class TopBarItem: TopBarItemProtocol {
    public var index: Int = -1
    public let title: String?
    
    public init(title: String?) {
        self.title = title
    }
}

// MARK: TopBar
open class TopBar: FormsComponent {
    public typealias OnSelect = ((_ item: TopBarItemProtocol) -> Void)

    private let contentView = UIView()
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: TopBarFlowLayout())
    private let separatorView = UIView()
    private let underlineView = UIView()
    
    open var fillEqual: Bool = false {
        didSet { self.collectionView.reloadData() }
    }
    open var isSeparator: Bool = true {
        didSet { self.separatorView.isHidden = !self.isSeparator }
    }
    open var isUnderlineRounded: Bool = false {
        didSet { self.underlineView.layer.cornerRadius = self.isUnderlineRounded ? 1.75 : 0.0 }
    }
    open var separatorColor: UIColor? = Theme.Colors.gray {
        didSet { self.separatorView.backgroundColor = self.separatorColor }
    }
    open var titleColor: UIColor? = Theme.Colors.primaryText {
        didSet { self.collectionView.reloadData() }
    }
    open var titleEdgeInset: UIEdgeInsets = UIEdgeInsets(vertical: 8, horizontal: 16) {
        didSet { self.collectionView.reloadData() }
    }
    open var titleFont: UIFont = Theme.Fonts.regular(ofSize: 14) {
        didSet { self.collectionView.reloadData() }
    }
    open var titleSelectedColor: UIColor? = Theme.Colors.primaryText {
        didSet { self.collectionView.reloadData() }
    }
    open var titleSelectedFont: UIFont = Theme.Fonts.bold(ofSize: 14) {
        didSet { self.collectionView.reloadData() }
    }
    open var underlineColor: UIColor? = Theme.Colors.primaryText {
        didSet { self.underlineView.backgroundColor = self.underlineColor }
    }
    
    private var topBarItems: [TopBarItemProtocol] = []
    private var selectedIndex: Int? = nil
    private let defaultCellIdentifier: String = "_cell"
    
    public var onSelect: OnSelect? = nil
    
    override open func setupView() {
        super.setupView()
        self.clipsToBounds = false
        self.setupContent()
        self.setupCollection()
        self.setupSeparator()
        self.setupUnderline()
    }
    
    private func setupContent() {
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = self.backgroundColor
        self.addSubview(self.contentView, with: [
            Anchor.to(self).top.horizontal,
            Anchor.to(self).bottom.priority(.defaultHigh),
            Anchor.to(self.contentView).height(44)
        ])
    }
    
    private func setupCollection() {
        self.collectionView.clipsToBounds = true
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        }
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.frame = self.bounds
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.alwaysBounceHorizontal = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.defaultCellIdentifier)
        self.contentView.addSubview(self.collectionView, with: [
            Anchor.to(self.contentView).fill
        ])
    }
    
    private func setupSeparator() {
        self.separatorView.backgroundColor = self.separatorColor
        self.separatorView.isHidden = !self.isSeparator
        self.contentView.addSubview(self.separatorView, with: [
            Anchor.to(self.contentView).horizontal.bottom,
            Anchor.to(self.separatorView).height(0.5)
        ])
    }
    
    private func setupUnderline() {
        self.underlineView.backgroundColor = self.underlineColor
        self.underlineView.layer.cornerRadius = self.isUnderlineRounded ? 1.75 : 0.0
        self.underlineView.frame = CGRect( x: 0, y: 42, width: 0, height: 3.5)
        self.addSubview(self.underlineView)
    }
    
    public func selectIndex(_ index: Int,
                            animated: Bool = true) {
        self.selectedIndex = index
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        self.updateUnderline(index: CGFloat(index), animated: animated)
        self.collectionView.scrollToItem(
            at: IndexPath(row: index, section: 0),
            at: .centeredHorizontally,
            animated: true)
    }
    
    public func selectIndex(_ index: CGFloat,
                            animated: Bool = true) {
        self.updateUnderline(index: index, animated: animated)
        let newIndex: Int = Int(round(index))
        guard newIndex != self.selectedIndex else { return }
        self.selectIndex(newIndex, animated: animated)
    }
    
    public func setItems(_ items: [TopBarItemProtocol],
                         index: Int = 0) {
        self.topBarItems = items
        self.selectIndex(index, animated: false)
    }
    
    private func createItem(index: Int) -> UILabel {
        let isSelected: Bool = index == self.selectedIndex
        let item: TopBarItemProtocol? = self.topBarItems[safe: index]
        let titleLabel = UILabel()
        titleLabel.tag = index
        titleLabel.isUserInteractionEnabled = true
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.text = item?.title
        titleLabel.textColor = isSelected
            ? self.titleSelectedColor
            : self.titleColor
        titleLabel.font = isSelected
            ? self.titleSelectedFont
            : self.titleFont
        return titleLabel
    }
    
    private func updateUnderline(index: CGFloat,
                                 animated: Bool = true) {
        let from: Int = Int(floor(index))
        let fromRatio: CGFloat = (index - from.asCGFloat).reversed(progress: 1.0)
        let to: Int = Int(ceil(index))
        let toRatio: CGFloat = fromRatio.reversed(progress: 1.0)
        guard let fromCell = self.collectionView.cellForItem(at: IndexPath(row: from, section: 0)) else { return }
        guard let toCell = self.collectionView.cellForItem(at: IndexPath(row: to, section: 0)) else {
            self.animation(animated, duration: 0.2) {
                self.underlineView.frame.size.width = fromCell.frame.width * 0.9
                self.underlineView.center.x = fromCell.center.x - self.collectionView.contentOffset.x
            }
            return
        }
        self.animation(animated, duration: 0.2) {
            self.underlineView.frame.size.width = (fromCell.frame.width * fromRatio + toCell.frame.width * toRatio) * 0.9
            self.underlineView.center.x = (fromCell.center.x * fromRatio + toCell.center.x * toRatio) - self.collectionView.contentOffset.x
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, TopBarDelegateFlowLayout
extension TopBar: UICollectionViewDelegate, UICollectionViewDataSource, TopBarDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.topBarItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item: TopBarItemProtocol = self.topBarItems[indexPath.row]
        self.onSelect?(item)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: self.defaultCellIdentifier, for: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let view: UIView = self.createItem(index: indexPath.row)
        cell.contentView.subviews.removeFromSuperview()
        cell.contentView.addSubview(view, with: [
            Anchor.to(cell.contentView).top.offset(self.titleEdgeInset.top),
            Anchor.to(cell.contentView).bottom.offset(self.titleEdgeInset.bottom),
            Anchor.to(cell.contentView).leading.offset(self.titleEdgeInset.leading),
            Anchor.to(cell.contentView).trailing.offset(self.titleEdgeInset.trailing)
        ])
    }
    
    public func collectionView(_ collectionView: UICollectionView, widthForItemAt indexPath: IndexPath) -> CGFloat {
        guard !self.fillEqual else {
            return collectionView.frame.width / CGFloat(self.topBarItems.count)
        }
        let label: UILabel = self.createItem(index: indexPath.row)
        let size: CGSize = label.sizeThatFits(CGSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: self.frame.height - self.titleEdgeInset.vertical))
        return size.width + self.titleEdgeInset.horizontal
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let index: Int = self.selectedIndex else { return }
        self.updateUnderline(index: CGFloat(index), animated: true)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let index: Int = self.selectedIndex else { return }
        guard scrollView.isDragging || scrollView.isDecelerating else { return }
        self.updateUnderline(index: CGFloat(index), animated: false)
    }
}

// MARK: TopBarDelegateFlowLayout
public protocol TopBarDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, widthForItemAt indexPath: IndexPath) -> CGFloat
}

// MARK: PagerFlowLayout
private class TopBarFlowLayout: UICollectionViewFlowLayout {
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentSize: CGSize = CGSize()
    
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    override func prepare() {
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        guard let collectionView = self.collectionView else { return }
        guard let delegate = collectionView.superview?.superview as? TopBarDelegateFlowLayout else { return }
        guard self.cache.isEmpty else { return }
        var offset: CGFloat = 0
        let height: CGFloat = collectionView.frame.height
        let count: Int = collectionView.numberOfItems(inSection: 0)
        for item in 0 ..< count {
            let indexPath = IndexPath(item: item, section: 0)
            let width: CGFloat = delegate.collectionView(collectionView, widthForItemAt: indexPath)
            let frame: CGRect = CGRect(x: offset, y: 0, width: width, height: height)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            self.cache.append(attributes)
            offset += width
        }
        offset = self.normalizeAttributes(
            totalOffset: offset,
            collectionWidth: collectionView.bounds.width)
        self.contentSize = CGSize(width: offset, height: height)
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        self.cache = []
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in self.cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    private func normalizeAttributes(totalOffset: CGFloat,
                                     collectionWidth: CGFloat) -> CGFloat {
        guard totalOffset != 0 else { return 0 }
        guard totalOffset <= collectionWidth else { return totalOffset }
        let ratio: CGFloat = collectionWidth / totalOffset
        var offset: CGFloat = 0
        for attributes in self.cache {
            attributes.frame.origin.x = offset
            attributes.frame.size.width *= ratio
            offset += attributes.frame.size.width
        }
        return offset
    }
}
