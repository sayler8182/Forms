//
//  FormsPagerController.swift
//  Forms
//
//  Created by Konrad on 4/6/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import UIKit

// MARK: PagerItem
open class PagerItem: TopBarItem {
    public typealias OnSelect = ((_ item: PagerItem) -> Void)
    
    private var _viewControllerFactory: () -> UIViewController
    public let onSelect: OnSelect?
    
    private var _viewController: UIViewController?
    public var viewController: UIViewController {
        if self._viewController.isNil {
            self._viewController = self._viewControllerFactory()
        }
        return self._viewController! // swiftlint:disable:this force_unwrapping
    }
    
    public init(viewController: @escaping () -> UIViewController,
                title: String? = nil,
                onSelect: OnSelect? = nil) {
        self._viewControllerFactory = viewController
        self.onSelect = onSelect
        super.init(title: title)
    }
}

// MARK: FormsPagerController
open class FormsPagerController: FormsViewController {
    private let topBar = TopBar(width: 320, height: 44)
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PagerFlowLayout())
    private let pageControl = UIPageControl()
    
    private let topBarHeightAnchor = AnchorConnection()
    private let collectionBottomAnchor = AnchorConnection()
    private let collectionToPageBottomAnchor = AnchorConnection()
    private let pageControlHeightAnchor = AnchorConnection()
    
    private var items: [PagerItem] = []
    private var selectedIndex: Int? = nil
    private let defaultCellIdentifier: String = "_cell"
    
    open var bounces: Bool = true {
        didSet { self.collectionView.bounces = self.bounces }
    }
    open var isTranslucent: Bool = false {
        didSet { self.updateTranslucent() }
    }
    open var pageBackgroundColor: UIColor? = nil {
        didSet { self.pageControl.backgroundColor = self.pageBackgroundColor }
    }
    open var pageIndicatorTintColor: UIColor? = Theme.Colors.gray {
        didSet { self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor }
    }
    open var pageCurrentPageIndicatorTintColor: UIColor? = UIColor.gray {
        didSet { self.pageControl.currentPageIndicatorTintColor = self.pageCurrentPageIndicatorTintColor }
    }
    open var topBarBackgroundColor: UIColor? = Theme.Colors.primaryBackground {
        didSet { self.topBar.backgroundColor = self.topBarBackgroundColor }
    }
    open var topBarFillEqual: Bool = false {
        didSet { self.topBar.fillEqual = self.topBarFillEqual }
    }
    open var topBarIsSeparator: Bool = true {
        didSet { self.topBar.isSeparator = self.topBarIsSeparator }
    }
    open var topBarIsUnderlineRounded: Bool = false {
        didSet { self.topBar.isUnderlineRounded = self.topBarIsUnderlineRounded }
    }
    open var topBarSeparatorColor: UIColor? = Theme.Colors.gray {
        didSet { self.topBar.separatorColor = self.topBarSeparatorColor }
    }
    open var topBarTitleColor: UIColor? = Theme.Colors.primaryText {
        didSet { self.topBar.titleColor = self.topBarTitleColor }
    }
    open var topBarTitleEdgeInset: UIEdgeInsets = UIEdgeInsets(vertical: 8, horizontal: 16) {
        didSet { self.topBar.titleEdgeInset = self.topBarTitleEdgeInset }
    }
    open var topBarTitleFont: UIFont = Theme.Fonts.regular(ofSize: 14) {
        didSet { self.topBar.titleFont = self.topBarTitleFont }
    }
    open var topBarTitleSelectedColor: UIColor? = Theme.Colors.primaryText {
        didSet { self.topBar.titleSelectedColor = self.topBarTitleSelectedColor }
    }
    open var topBarTitleSelectedFont: UIFont = Theme.Fonts.bold(ofSize: 14) {
        didSet { self.topBar.titleSelectedFont = self.topBarTitleSelectedFont }
    }
    open var topBarUnderlineColor: UIColor? = Theme.Colors.primaryText {
        didSet { self.topBar.underlineColor = self.topBarUnderlineColor }
    }
    
    public var onSelect: PagerItem.OnSelect? = nil
    
    override open func setupView() {
        super.setupView()
        self.setupTopBar()
        self.setupCollectionView()
        self.setupPageControl()
        self.setupItems()
    }
    
    open func setupTopBar() {
        self.topBar.backgroundColor = self.topBarBackgroundColor
        self.topBar.fillEqual = self.topBarFillEqual
        self.topBar.isSeparator = self.topBarIsSeparator
        self.topBar.isUnderlineRounded = self.topBarIsUnderlineRounded
        self.topBar.separatorColor = self.topBarSeparatorColor
        self.topBar.titleColor = self.topBarTitleColor
        self.topBar.titleFont = self.topBarTitleFont
        self.topBar.titleEdgeInset = self.topBarTitleEdgeInset
        self.topBar.titleSelectedColor = self.topBarTitleSelectedColor
        self.topBar.titleSelectedFont = self.topBarTitleSelectedFont
        self.topBar.underlineColor = self.topBarUnderlineColor
        self.view.addSubview(self.topBar, with: [
            Anchor.to(self.view).top.safeArea,
            Anchor.to(self.view).horizontal,
            Anchor.to(self.topBar)
                .height(0.0)
                .connect(self.topBarHeightAnchor)
                .isActive(false)
        ])
        self.topBar.onSelect = { [unowned self] (item) in
            self.showPage(at: item.index)
        }
    }
    
    open func setupCollectionView() {
        self.collectionView.bounces = self.bounces
        self.collectionView.clipsToBounds = true
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        }
        self.collectionView.backgroundColor = self.view.backgroundColor
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentMode = .top
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.defaultCellIdentifier)
        self.view.addSubview(self.collectionView, with: [
            Anchor.to(self.topBar).topToBottom,
            Anchor.to(self.view).horizontal,
            Anchor.to(self.view).bottom
                .connect(self.collectionBottomAnchor)
                .isActive(false)
        ])
        self.view.sendSubviewToBack(self.collectionView)
    }
    
    open func setupPageControl() {
        self.pageControl.clipsToBounds = true
        self.pageControl.isUserInteractionEnabled = false
        self.pageControl.numberOfPages = 0
        self.pageControl.backgroundColor = self.pageBackgroundColor
        self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor
        self.pageControl.currentPageIndicatorTintColor = self.pageCurrentPageIndicatorTintColor
        self.pageControl.alpha = 0
        self.pageControl.isHidden = true
        self.view.addSubview(self.pageControl, with: [
            Anchor.to(self.collectionView).topToBottom
                .connect(self.collectionToPageBottomAnchor)
                .priority(.defaultHigh),
            Anchor.to(self.view).horizontal,
            Anchor.to(self.view).bottom.safeArea,
            Anchor.to(self.pageControl).height(0).connect(self.pageControlHeightAnchor)
        ])
    }
    
    override open func setTheme() {
        self.topBarBackgroundColor = Theme.Colors.primaryBackground
        self.topBarTitleColor = Theme.Colors.primaryText
        self.topBarTitleFont = Theme.Fonts.regular(ofSize: 14)
        self.topBarTitleSelectedColor = Theme.Colors.primaryText
        self.topBarTitleSelectedFont = Theme.Fonts.bold(ofSize: 14)
        self.topBarUnderlineColor = Theme.Colors.primaryText
        super.setTheme()
    }
    
    open func setupItems() {
        // HOOK
    }
    
    public func showPage(at index: Int,
                         animated: Bool = true) {
        let index: Int = index.match(from: 0, to: self.items.count - 1)
        let indexPath = IndexPath(row: index, section: 0)
        self.collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: animated)
        self.selectedIndex = index
    }
    
    public func setItems(_ items: [PagerItem]) {
        items.enumerated().forEach { (i, item) in
            item.index = i
        }
        self.items = items
        self.topBar.setItems(items)
        self.pageControl.numberOfPages = items.count
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func updateTranslucent() {
        self.collectionToPageBottomAnchor.constraint?.isActive = !self.isTranslucent
        self.collectionBottomAnchor.constraint?.isActive = self.isTranslucent
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: TopBar
public extension FormsPagerController {
    func showTopBar(animated: Bool = true,
                    completion: ((Bool) -> Void)? = nil) {
        self.collectionView.performBatchUpdates({
            self.view.sendSubviewToBack(self.collectionView)
            self.topBar.isHidden = false
            self.view.animation(
                animated,
                duration: 0.3,
                animations: {
                    self.topBar.alpha = 1
                    self.topBarHeightAnchor.constraint?.isActive = false
                    self.view.layoutIfNeeded()
            }, completion: completion)
        }, completion: nil)
    }
    
    func hideTopBar(animated: Bool = true,
                    completion: ((Bool) -> Void)? = nil) {
        self.collectionView.performBatchUpdates({
            self.view.sendSubviewToBack(self.topBar)
            self.view.animation(
                animated,
                duration: 0.3,
                animations: {
                    self.topBar.alpha = 0
                    self.topBarHeightAnchor.constraint?.isActive = true
                    self.view.layoutIfNeeded()
            }, completion: { (status) in
                self.topBar.isHidden = true
                completion?(status)
            })
        }, completion: nil)
    }
}

// MARK: Page control
public extension FormsPagerController {
    func showPageControl(animated: Bool = true,
                         completion: ((Bool) -> Void)? = nil) {
        self.collectionView.performBatchUpdates({
            self.pageControl.isHidden = false
            self.view.animation(
                animated,
                duration: 0.3,
                animations: {
                    self.pageControl.alpha = 1
                    self.pageControlHeightAnchor.constant = 30
                    self.view.layoutIfNeeded()
            }, completion: completion)
        }, completion: nil)
    }
    
    func hidePageControl(animated: Bool = true,
                         completion: ((Bool) -> Void)? = nil) {
        self.collectionView.performBatchUpdates({
            self.view.animation(
                animated,
                duration: 0.3,
                animations: {
                    self.pageControl.alpha = 0
                    self.pageControlHeightAnchor.constant = 0
                    self.view.layoutIfNeeded()
            }, completion: { (status) in
                self.pageControl.isHidden = true
                completion?(status)
            })
        }, completion: nil)
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension FormsPagerController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let item: PagerItem = self.items[indexPath.row]
        let viewController: UIViewController = item.viewController
        viewController.view.frame = collectionView.bounds
        self.addChild(viewController)
        cell.contentView.subviews.removeFromSuperview()
        cell.contentView.addSubview(viewController.view, with: [
            Anchor.to(cell.contentView).fill
        ])
        viewController.didMove(toParent: self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item: PagerItem = self.items[indexPath.row]
        let viewController: UIViewController = item.viewController
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        cell.contentView.subviews.removeFromSuperview()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

// MARK: UIScrollViewDelegate
extension FormsPagerController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width: CGFloat = scrollView.frame.width
        let x: CGFloat = scrollView.contentOffset.x
        let index: Int = Int(round(x / width))
        self.topBar.selectIndex(x / width)
        guard index.inRange(0..<self.items.count) else { return }
        guard index != self.selectedIndex else { return }
        self.selectedIndex = index
        self.pageControl.currentPage = index
        let item: PagerItem = self.items[index]
        self.onSelect?(item)
        item.onSelect?(item)
    }
}

// MARK: PagerFlowLayout
private class PagerFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare() {
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        super.prepare()
    }
}
