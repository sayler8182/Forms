//
//  PageContainer.swift
//  Forms
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: PageContainer
open class PageContainer: FormsComponent, FormsComponentWithMarginEdgeInset, FormsComponentWithPaddingEdgeInset {
    public typealias OnSelect = ((FormsComponent) -> Void)
    
    private let backgroundView = UIView()
    private lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
    private let pageControl = UIPageControl()
    
    private var flowLayout = PageContainerFlowLayout()
    private var items: [FormsComponent] = []
    private var selectedIndex: Int? = nil
    private let defaultCellIdentifier: String = "_cell"
    private var timer: Timer? = nil
    private var isAutomaticPaused: Bool = false
    
    open var automaticInterval: TimeInterval = 0 {
        didSet { self.updateAutomatic() }
    }
    override open var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
    }
    open var bounces: Bool {
        get { return self.collectionView.bounces }
        set { self.collectionView.bounces = newValue }
    }
    open var height: CGFloat = UITableView.automaticDimension
    open var isAutomatic: Bool = false {
        didSet { self.updateAutomatic() }
    }
    open var isPagingEnabled: Bool {
        get { return self.collectionView.isPagingEnabled }
        set { self.collectionView.isPagingEnabled = newValue }
    }
    open var marginEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updateMarginEdgeInset() }
    }
    open var paddingEdgeInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.updatePaddingEdgeInset() }
    }
    open var pageBackgroundColor: UIColor? {
        get { return self.pageControl.backgroundColor }
        set { self.pageControl.backgroundColor = newValue }
    }
    open var pageIndicatorTintColor: UIColor? {
        get { return self.pageControl.pageIndicatorTintColor }
        set { self.pageControl.pageIndicatorTintColor = newValue }
    }
    open var pageCurrentPageIndicatorTintColor: UIColor? {
        get { return self.pageControl.currentPageIndicatorTintColor }
        set { self.pageControl.currentPageIndicatorTintColor = newValue }
    }
    open var pageIsHidden: Bool {
        get { return self.pageControl.isHidden }
        set { self.pageControl.isHidden = newValue }
    }
    open var scrollDirection: UICollectionView.ScrollDirection {
        get { return self.flowLayout.scrollDirection }
        set { self.flowLayout.scrollDirection = newValue }
    }
    
    public var onSelect: OnSelect? = nil
    
    override open func setupView() {
        self.setupBackgroundView()
        self.setupCollectionView()
        self.setupPageControl()
        super.setupView()
    }
    
    deinit {
        self.timer?.invalidate()
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
    
    private func setupCollectionView() {
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.frame = self.backgroundView.bounds
        self.collectionView.clipsToBounds = true
        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentMode = .top
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.defaultCellIdentifier)
        self.backgroundView.addSubview(self.collectionView, with: [
            Anchor.to(self.backgroundView).fill
        ])
    }
    
    private func setupPageControl() {
        self.pageControl.clipsToBounds = true
        self.pageControl.isUserInteractionEnabled = false
        self.pageControl.numberOfPages = 0
        self.backgroundView.addSubview(self.pageControl, with: [
            Anchor.to(self.backgroundView).horizontal,
            Anchor.to(self.backgroundView).bottom
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
        self.collectionView.frame = self.bounds.with(inset: edgeInset)
        self.collectionView.constraint(to: self.backgroundView, position: .top)?.constant = edgeInset.top
        self.collectionView.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.collectionView.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.collectionView.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
        self.pageControl.frame = self.bounds.with(inset: edgeInset)
        self.pageControl.constraint(to: self.backgroundView, position: .bottom)?.constant = -edgeInset.bottom
        self.pageControl.constraint(to: self.backgroundView, position: .leading)?.constant = edgeInset.leading
        self.pageControl.constraint(to: self.backgroundView, position: .trailing)?.constant = -edgeInset.trailing
    }
    
    private func updateAutomatic() {
        self.timer?.invalidate()
        guard self.isAutomatic else { return }
        guard !self.isAutomaticPaused else { return }
        let timer = Timer(timeInterval: self.automaticInterval, repeats: true, block: { [weak self] _ in
            guard let `self` = self else { return }
            guard !self.isAutomaticPaused else { return }
            var nextIndex: Int = self.selectedIndex.or(0) + 1
            nextIndex = nextIndex.inRange(0..<self.items.count)
                ? nextIndex
                : 0
            self.scrollTo(index: nextIndex, animated: true)
        })
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        self.timer = timer
    }
    
    public func setItems(_ items: [FormsComponent]) {
        self.items = items
        self.pageControl.alpha = items.isEmpty ? 0.0 : 1.0
        self.pageControl.numberOfPages = items.count
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    public func scrollTo(component: FormsComponent,
                         animated: Bool = true) {
        guard let index: Int = self.items.firstIndex(of: component) else { return }
        self.scrollTo(index: index, animated: animated)
    }
    
    private func scrollTo(index: Int,
                          animated: Bool = true) {
        let index: Int = min(max(0, index), self.items.count - 1)
        let indexPath = IndexPath(row: index, section: 0)
        let position = self.scrollDirection == .horizontal
            ? UICollectionView.ScrollPosition.centeredHorizontally
            : UICollectionView.ScrollPosition.centeredVertically
        self.collectionView.scrollToItem(
            at: indexPath,
            at: position,
            animated: animated)
        self.selectedIndex = index
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PageContainer: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let item: FormsComponent = self.items[indexPath.row]
        item.frame = collectionView.bounds
        cell.contentView.subviews.removeFromSuperview()
        cell.contentView.addSubview(item, with: [
            Anchor.to(cell.contentView).fill
        ])
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.subviews.removeFromSuperview()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

// MARK: UIScrollViewDelegate
extension PageContainer: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isAutomaticPaused = true
        self.updateAutomatic()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.isAutomaticPaused = false
        self.updateAutomatic()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width: CGFloat = scrollView.frame.width
        let height: CGFloat = scrollView.frame.height
        let x: CGFloat = scrollView.contentOffset.x
        let y: CGFloat = scrollView.contentOffset.y
        let index: Int = self.scrollDirection == .horizontal
            ? Int(round(x / width))
            : Int(round(y / height))
        guard index.inRange(0..<self.items.count) else { return }
        guard index != self.selectedIndex else { return }
        self.selectedIndex = index
        self.pageControl.currentPage = index
        let item: FormsComponent = self.items[index]
        self.onSelect?(item)
    }
}

// MARK: Builder
public extension PageContainer {
    func with(automaticInterval: TimeInterval) -> Self {
        self.automaticInterval = automaticInterval
        return self
    }
    func with(bounces: Bool) -> Self {
        self.bounces = bounces
        return self
    }
    @objc
    override func with(height: CGFloat) -> Self {
        self.height = height
        return self
    }
    func with(isAutomatic: Bool) -> Self {
        self.isAutomatic = isAutomatic
        return self
    }
    func with(isPagingEnabled: Bool) -> Self {
        self.isPagingEnabled = isPagingEnabled
        return self
    }
    func with(items: [FormsComponent]) -> Self {
        self.setItems(items)
        return self
    }
    func with(pageBackgroundColor: UIColor?) -> Self {
        self.pageBackgroundColor = pageBackgroundColor
        return self
    }
    func with(pageIndicatorTintColor: UIColor?) -> Self {
        self.pageIndicatorTintColor = pageIndicatorTintColor
        return self
    }
    func with(pageCurrentPageIndicatorTintColor: UIColor?) -> Self {
        self.pageCurrentPageIndicatorTintColor = pageCurrentPageIndicatorTintColor
        return self
    }
    func with(pageIsHidden: Bool) -> Self {
        self.pageIsHidden = pageIsHidden
        return self
    }
    func with(scrollDirection: UICollectionView.ScrollDirection) -> Self {
        self.scrollDirection = scrollDirection
        return self
    }
}

// MARK: PageContainerFlowLayout
private class PageContainerFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.scrollDirection = .horizontal
    }
    
    init(scrollDirection: UICollectionView.ScrollDirection) {
        super.init()
        self.scrollDirection = scrollDirection
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.scrollDirection = .horizontal
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare() {
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        super.prepare()
    }
}
