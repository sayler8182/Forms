//
//  FormsCollectionViewController.swift
//  Forms
//
//  Created by Konrad on 4/24/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsValidators
import UIKit

// MARK: CollectionProtocol
public protocol CollectionProtocol: class {
    func refreshCollectionView()
    func refreshCollectionView(animated: Bool)
}

// MARK: FormsCollectionViewController
open class FormsCollectionViewController: FormsViewController, UICollectionViewDelegate, UICollectionViewDataSource, CollectionDataSourceDelegateProtocol, CollectionProtocol {
    private let collectionUpdatesQueue: DispatchQueue = DispatchQueue(
        label: "collectionUpdatesQueue",
        target: DispatchQueue.main)
    private let headerView: UIView = UIView(width: 320, height: 44)
    private let footerView: UIStackView = UIStackView()
    private let defaultCellIdentifier: String = "_cell"
    
    private lazy var collectionView: UICollectionView = UICollectionView(
        frame: CGRect(width: 320, height: 44),
        collectionViewLayout: self.flowLayout)
    private lazy var flowLayout = CollectionFlowLayout(
        scrollDirection: self.collectionScrollDirection)
    private var refreshControl: UIRefreshControl? = nil
    private var shimmerDataSource: ShimmerCollectionDataSource? = nil
    
    open var cellBackgroundColor: UIColor = UIColor.clear {
        didSet { self.collectionView.reloadData() }
    }
    open var footerBackgroundColor: UIColor = UIColor.clear {
        didSet { self.footerView.backgroundColor = self.footerBackgroundColor }
    }
    open var footerSpacing: CGFloat = 8 {
        didSet { self.footerView.spacing = self.footerSpacing }
    }
    open var headerBackgroundColor: UIColor = UIColor.clear {
        didSet { self.headerView.backgroundColor = self.headerBackgroundColor }
    }
    open var isBottomToSafeArea: Bool = true
    open var isTopToSafeArea: Bool = true
    open var keyboardDismissMode: UIScrollView.KeyboardDismissMode = .interactive {
        didSet { self.collectionView.keyboardDismissMode = self.keyboardDismissMode }
    }
    open var paginationDelayExpiration: TimeInterval = 0
    open var paginationIsAutostart: Bool = true
    open var paginationIsLoading: Bool = false
    open var paginationIsEnabled: Bool = false
    open var paginationIsFinished: Bool = false
    open var paginationOffset: CGFloat = 0
    open var pullToRefreshIsLoading: Bool = false
    open var pullToRefreshIsEnabled: Bool = false
    open var collectionAllowsSelection: Bool = false {
        didSet { self.collectionView.allowsSelection = self.collectionAllowsSelection }
    }
    open var collectionAlwaysBounceHorizontal: Bool = false {
        didSet { self.collectionView.alwaysBounceHorizontal = self.collectionAlwaysBounceHorizontal }
    }
    open var collectionAlwaysBounceVertical: Bool = false {
        didSet { self.collectionView.alwaysBounceVertical = self.collectionAlwaysBounceVertical }
    }
    open var collectionBackgroundColor: UIColor = UIColor.clear {
        didSet { self.collectionView.backgroundColor = self.collectionBackgroundColor }
    }
    open var collectionContentInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.flowLayout.contentInset = self.collectionContentInset }
    }
    open var collectionColumnsCount: Int = 1 {
        didSet { self.flowLayout.columnsCount = self.collectionColumnsCount }
    }
    open var collectionColumnsHorizontalDistance: CGFloat = 0 {
        didSet { self.flowLayout.columnsHorizontalDistance = self.collectionColumnsHorizontalDistance }
    }
    open var collectionColumnsVerticalDistance: CGFloat = 0 {
        didSet { self.flowLayout.columnsVerticalDistance = self.collectionColumnsVerticalDistance }
    }
    open var collectionScrollDirection: UICollectionView.ScrollDirection = .vertical {
        didSet { self.flowLayout.scrollDirection = self.collectionScrollDirection }
    }
    
    override open func setupView() {
        super.setupView()
        self.setupHeaderView()
        self.setupCollectionView()
        self.setupDataSource()
        self.setupFooterView()
        
        // HOOKS
        self.setupHeader()
        self.setupFooter()
        self.setupPagination()
        self.setupPullToRefresh()
    }
     
    override public func startShimmering(animated: Bool = true) {
        let shimmerDataSource = ShimmerCollectionDataSource()
            .with(generators: [ShimmerItemGenerator(type: ShimmerCollectionViewCell.self, count: 20)])
        self.startShimmering(
            shimmerDataSource,
            animated: animated)
    }
    
    public func startShimmering(_ shimmerDataSource: ShimmerCollectionDataSource,
                                animated: Bool = true) {
        shimmerDataSource.prepare(
            for: self.collectionView,
            queue: self.collectionUpdatesQueue,
            scrollDelegate: self)
        shimmerDataSource.prepareGenerators()
        self.shimmerDataSource = shimmerDataSource
        self.setDataSource(
            delegate: shimmerDataSource,
            dataSource: shimmerDataSource)
    }
    
    override public func stopShimmering(animated: Bool = true) {
        self.shimmerDataSource?.stopShimmering(animated: animated)
    }
    
    public func stopShimmering(newDataSource: CollectionDataSource?,
                               animated: Bool = true) {
        self.shimmerDataSource?.stopShimmering(animated: animated)
        self.shimmerDataSource = nil
        newDataSource?.prepare(
            for: self.collectionView,
            queue: self.collectionUpdatesQueue,
            scrollDelegate: self)
        self.setDataSource(
            delegate: newDataSource,
            dataSource: newDataSource)
    }
    
    private func setupHeaderView() {
        self.headerView.backgroundColor = self.headerBackgroundColor
        let layoutGuide: LayoutGuide = self.isTopToSafeArea ? .safeArea : .normal
        self.view.addSubview(self.headerView, with: [
            Anchor.to(self.view).top.layoutGuide(layoutGuide),
            Anchor.to(self.view).horizontal,
            Anchor.to(self.headerView).height(0.0).lowPriority
        ])
    }
    
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.keyboardDismissMode = self.keyboardDismissMode
        self.collectionView.backgroundColor = self.collectionBackgroundColor
        self.collectionView.allowsSelection = self.collectionAllowsSelection
        self.collectionView.alwaysBounceHorizontal = self.collectionAlwaysBounceHorizontal
        self.collectionView.alwaysBounceVertical = self.collectionAlwaysBounceVertical
        self.view.addSubview(self.collectionView, with: [
            Anchor.to(self.headerView).topToBottom,
            Anchor.to(self.view).horizontal
        ])
    }
    
    private func setupFooterView() {
        self.footerView.backgroundColor = self.footerBackgroundColor
        self.footerView.alignment = UIStackView.Alignment.fill
        self.footerView.axis = NSLayoutConstraint.Axis.vertical
        self.footerView.distribution = UIStackView.Distribution.equalSpacing
        self.footerView.spacing = self.footerSpacing
        let layoutGuide: LayoutGuide = self.isBottomToSafeArea ? .safeArea : .normal
        self.view.addSubview(self.footerView, with: [
            Anchor.to(self.collectionView).topToBottom,
            Anchor.to(self.view).bottom.layoutGuide(layoutGuide).connect(self.bottomAnchor),
            Anchor.to(self.view).horizontal,
            Anchor.to(self.footerView).height(0.0).lowPriority
        ])
    }
    
    // MARK: HOOKS
    open func setupHeader() {
        // HOOK
    }
    
    open func setupDataSource() {
        // HOOK
    }
    
    open func setupFooter() {
        // HOOK
    }
    
    open func setupCell(item: CollectionItem,
                        cell: FormsCollectionViewCell,
                        indexPath: IndexPath) {
        // HOOK
    }
    
    open func selectCell(item: CollectionItem,
                         cell: FormsCollectionViewCell,
                         indexPath: IndexPath) {
        // HOOK
    }
    
    open func setupPagination() {
        guard self.paginationIsAutostart else { return }
        self.paginationRaise()
        // HOOK
    }
    
    open func paginationNext() {
        // HOOK
    }
    
    open func setupPullToRefresh() {
        guard self.pullToRefreshIsEnabled else { return }
        self.setPullToRefresh()
        // HOOK
    }
    
    open func pullToRefresh() {
        // HOOK
    }
}

// MARK: Header
public extension FormsCollectionViewController {
    func setHeader(_ view: UIView,
                   height: CGFloat? = nil) {
        self.headerView.subviews.removeFromSuperview()
        if let height: CGFloat = height {
            self.headerView.addSubview(view, with: [
                Anchor.to(self.headerView).fill,
                Anchor.to(view).height(height)
            ])
        } else {
            self.headerView.addSubview(view, with: [
                Anchor.to(self.headerView).fill
            ])
        }
    }
}

// MARK: Footer
public extension FormsCollectionViewController {
    func addToFooter(_ views: [UIView],
                     height: CGFloat? = nil) {
        for view in views {
            self.addToFooter(view, height: height)
        }
    }
    
    func addToFooter(_ view: UIView,
                     height: CGFloat? = nil) {
        let index: Int = self.footerView.arrangedSubviews.count
        self.insertToFooter(view, at: index, height: height)
    }
    
    func insertToFooter(_ views: [UIView],
                        at index: Int,
                        height: CGFloat? = nil) {
        for view in views {
            self.insertToFooter(view, at: index, height: height)
        }
    }
    
    func insertToFooter(_ view: UIView,
                        at index: Int,
                        height: CGFloat? = nil) {
        if let height: CGFloat = height {
            self.footerView.insertArrangedSubview(view, at: index, with: [
                Anchor.to(view).height(height)
            ])
        } else {
            self.footerView.insertArrangedSubview(view, at: index)
        }
    }
    
    func removeFromFooter(_ views: [UIView]) {
        for view in views {
            self.removeFromFooter(view)
        }
    }
    
    func removeFromFooter(_ view: UIView) {
        self.footerView.removeArrangedSubview(view)
    }
}
 
// MARK: CollectionView
public extension FormsCollectionViewController {
    func reloadData(animated: Bool = true) {
        self.collectionUpdatesQueue.async {
            self.collectionView.transition(
                animated,
                duration: 0.3,
                animations: self.collectionView.reloadData)
        }
    }
    
    func updateCollectioneView(animated: Bool = true,
                               update: (() -> Void)? = nil) {
        self.collectionUpdatesQueue.async {
            self.collectionView.shouldAnimate(animated) {
                self.collectionView.performBatchUpdates({
                    update?()
                })
            }
        }
    }
    
    func refreshCollectionView() {
        self.refreshCollectionView(animated: true)
    }
    
    func refreshCollectionView(animated: Bool) {
        self.collectionUpdatesQueue.async {
            self.collectionView.setNeedsLayout()
            self.collectionView.layoutIfNeeded()
            self.collectionView.shouldAnimate(animated) {
                self.collectionView.performBatchUpdates({})
            }
        }
    }
    
    func setDataSource(_ dataSource: CollectionDataSource?) {
        dataSource?.prepare(
            for: self.collectionView,
            queue: self.collectionUpdatesQueue,
            scrollDelegate: self)
        self.setDataSource(
            delegate: dataSource,
            dataSource: dataSource)
    }
    
    func setDataSource(delegate: UICollectionViewDelegate?,
                       dataSource: UICollectionViewDataSource?) {
        self.collectionUpdatesQueue.async {
            self.collectionView.delegate = delegate
            self.collectionView.dataSource = dataSource
        }
    }
}

// MARK: Pagination
public extension FormsCollectionViewController {
    func paginationSuccess(delay: TimeInterval = 0.5,
                           isLast: Bool = false) {
        self.paginationIsLoading = false
        self.paginationIsFinished = isLast
        self.paginationDelayExpiration = Date().timeIntervalSince1970 + delay
    }
    
    func paginationError(delay: TimeInterval = 5.0,
                         isLast: Bool = false) {
        self.paginationIsLoading = false
        self.paginationIsFinished = isLast
        self.paginationDelayExpiration = Date().timeIntervalSince1970 + delay
    }
    
    private func paginationShouldLoadNext(_ scrollView: UIScrollView) -> Bool {
        return scrollView.shouldLoadNext(
            offset: self.paginationOffset,
            scrollDirection: self.collectionScrollDirection)
    }
    
    private func paginationRaise() {
        guard self.paginationIsEnabled else { return }
        guard !self.paginationIsFinished else { return }
        guard !self.paginationIsLoading else { return }
        guard !self.pullToRefreshIsLoading else { return }
        guard self.paginationDelayExpiration < Date().timeIntervalSince1970 else { return }
        guard self.paginationShouldLoadNext(self.collectionView) else { return }
        self.paginationIsLoading = true
        self.paginationNext()
    }
}

// MARK: PullToRefresh
public extension FormsCollectionViewController {
    func setPullToRefresh(_ view: UIView) {
        let refreshControl = UIRefreshControl()
        refreshControl.addSubview(view)
        self.refreshControl = refreshControl
        self.pullToRefreshConfigure(refreshControl)
        self.collectionView.refreshControl = refreshControl
    }
    
    func setPullToRefresh(_ refreshControl: UIRefreshControl) {
        self.refreshControl = refreshControl
        self.pullToRefreshConfigure(refreshControl)
        self.collectionView.refreshControl = refreshControl
    }
    
    func setPullToRefresh() {
        let refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl
        self.pullToRefreshConfigure(refreshControl)
        self.collectionView.refreshControl = refreshControl
    }
    
    func pullToRefreshFinish() {
        self.refreshControl?.endRefreshing()
        self.pullToRefreshIsLoading = false
    }
    
    private func pullToRefreshConfigure(_ refreshControl: UIRefreshControl) {
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }
    
    @objc
    private func pullToRefresh(_ refreshControl: UIRefreshControl) {
        self.pullToRefreshIsLoading = true
        DispatchQueue.main.async {
            guard !self.paginationIsLoading else {
                self.pullToRefreshIsLoading = false
                return refreshControl.endRefreshing()
            }
            self.collectionView.panGestureRecognizer.isEnabled = false
            self.collectionView.panGestureRecognizer.isEnabled = true
            self.pullToRefresh()
        }
        // HOOK
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
public extension FormsCollectionViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

// MARK: UIScrollViewDelegate
public extension FormsCollectionViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.paginationRaise()
    }
}
    
// MARK: Scroll
public extension FormsCollectionViewController {
    func scroll(to index: Int,
                at position: UICollectionView.ScrollPosition = UICollectionView.ScrollPosition.centeredVertically,
                animated: Bool = true) {
        self.collectionUpdatesQueue.async {
            let indexPath: IndexPath = IndexPath(row: index, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: position, animated: animated)
        }
    }
}

// MARK: Inputs
extension FormsCollectionViewController { }

// MARK: CollectionDelegateFlowLayout
public protocol CollectionDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat?
    func collectionView(_ collectionView: UICollectionView, widthForItemAt indexPath: IndexPath) -> CGFloat?
}

// MARK: CollectionFlowLayout
open class CollectionFlowLayout: UICollectionViewFlowLayout {
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentSize: CGSize = CGSize()
    
    fileprivate var columnsCount: Int = 1 {
        didSet { self.invalidateLayout() }
    }
    fileprivate var columnsHorizontalDistance: CGFloat = 0 {
        didSet { self.invalidateLayout() }
    }
    fileprivate var columnsVerticalDistance: CGFloat = 0 {
        didSet { self.invalidateLayout() }
    }
    fileprivate var contentInset: UIEdgeInsets = UIEdgeInsets(0) {
        didSet { self.invalidateLayout() }
    }
    
    public var itemWidth: CGFloat {
        guard let collectionView = self.collectionView else { return 0.0 }
        return (collectionView.frame.width - (CGFloat(columnsCount - 1) * self.columnsHorizontalDistance) - self.contentInset.horizontal) / CGFloat(self.columnsCount)
    }
    
    public var itemHeight: CGFloat {
        guard let collectionView = self.collectionView else { return 0.0 }
        return (collectionView.frame.height - (CGFloat(self.columnsCount - 1) * self.columnsVerticalDistance) - self.contentInset.vertical) / CGFloat(self.columnsCount)
    }
    
    public init(scrollDirection: UICollectionView.ScrollDirection) {
        super.init()
        self.scrollDirection = scrollDirection
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.scrollDirection = .vertical
    }
    
    override public var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    override public func prepare() {
        self.itemSize = CGSize(width: 320, height: 320)
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        guard let delegate = collectionView.delegate as? CollectionDelegateFlowLayout else { return }
        guard self.cache.isEmpty else { return }
        self.scrollDirection == .vertical
            ? self.prepareVertical(collectionView: collectionView, delegate: delegate)
            : self.prepareHorizontal(collectionView: collectionView, delegate: delegate)
    }
    
    override public func invalidateLayout() {
        super.invalidateLayout()
        self.cache = []
    }
    
    private func prepareVertical(collectionView: UICollectionView,
                                 delegate: CollectionDelegateFlowLayout) {
        let contentInset: UIEdgeInsets = self.contentInset
        let columnsCount: Int = max(1, self.columnsCount)
        let width: CGFloat = self.itemWidth
        let sectionsCount: Int = collectionView.numberOfSections
        var offsetsY: [CGFloat] = [CGFloat](repeating: contentInset.top, count: columnsCount)
        let offsetsX: [CGFloat] = (0..<columnsCount).map { (column) -> CGFloat in
            return CGFloat(width) * CGFloat(column) + (CGFloat(column) * CGFloat(self.columnsHorizontalDistance) + CGFloat(contentInset.leading))
        }
        var itemIndex: Int = 0
        for section in 0 ..< sectionsCount {
            let itemsCount: Int = collectionView.numberOfItems(inSection: section)
            for item in 0 ..< itemsCount {
                let column: Int = itemIndex % columnsCount
                let indexPath = IndexPath(item: item, section: section)
                let height: CGFloat = delegate.collectionView(collectionView, heightForItemAt: indexPath) ?? 0
                let frame: CGRect = CGRect(x: offsetsX[column], y: offsetsY[column], width: width, height: height)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                self.cache.append(attributes)
                offsetsY[column] += height
                if item.lessThan(itemsCount - 1) {
                    offsetsY[column] += self.columnsVerticalDistance
                }
                itemIndex += 1
            }
        }
        let maxOffsetY: CGFloat = offsetsY.max() ?? contentInset.top
        self.contentSize = CGSize(
            width: collectionView.frame.width,
            height: maxOffsetY + contentInset.bottom)
    }
    
    private func prepareHorizontal(collectionView: UICollectionView,
                                   delegate: CollectionDelegateFlowLayout) {
        let contentInset: UIEdgeInsets = self.contentInset
        let columnsCount: Int = max(1, self.columnsCount)
        let height: CGFloat = self.itemHeight
        let sectionsCount: Int = collectionView.numberOfSections
        var offsetsX: [CGFloat] = [CGFloat](repeating: contentInset.leading, count: columnsCount)
        let offsetsY: [CGFloat] = (0..<columnsCount).map { (column) -> CGFloat in
            return CGFloat(height) * CGFloat(column) + (CGFloat(column) * CGFloat(self.columnsVerticalDistance) + CGFloat(contentInset.top))
        }
        var itemIndex: Int = 0
        for section in 0 ..< sectionsCount {
            let itemsCount: Int = collectionView.numberOfItems(inSection: section)
            for item in 0 ..< itemsCount {
                let column: Int = itemIndex % columnsCount
                let indexPath = IndexPath(item: item, section: section)
                let width: CGFloat = delegate.collectionView(collectionView, widthForItemAt: indexPath) ?? 0
                let frame: CGRect = CGRect(x: offsetsX[column], y: offsetsY[column], width: width, height: height)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                self.cache.append(attributes)
                offsetsX[column] += width
                if item.lessThan(itemsCount - 1) {
                    offsetsX[column] += self.columnsHorizontalDistance
                }
                itemIndex += 1
            }
        }
        let maxOffsetX: CGFloat = offsetsX.max() ?? contentInset.leading
        self.contentSize = CGSize(
            width: maxOffsetX + contentInset.trailing,
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
}
