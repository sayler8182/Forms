//
//  DemoShimmerPaginationCollectionViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/24/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoShimmerPaginationCollectionViewController
class DemoShimmerPaginationCollectionViewController: CollectionViewController {
    private lazy var navigationBar = Components.navigationBar.default()
        .with(rightBarButtonItems: [self.changeDirectionBarItem])
    
    private lazy var changeDirectionBarItem = BarItem()
        .with(imageSystemName: "arrow.clockwise")
    
    private lazy var shimmerDataSource = ShimmerCollectionDataSource()
        .with(generators: [ShimmerItemGenerator(type: ShimmerDemoCollectionViewCell.self, count: 3)])
        .with(delegate: self)
    
    private lazy var provider = DemoProvider(delegate: self)
    
    override func setupConfiguration() {
        super.setupConfiguration()
        self.isBottomToSafeArea = true
        self.paginationIsEnabled = true
        self.paginationOffset = 300
        self.pullToRefreshIsEnabled = false
        self.collectionAllowsSelection = true
        self.collectionContentInset = UIEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        self.collectionColumnsCount = 2
        self.collectionColumnsHorizontalDistance = 8
        self.collectionColumnsVerticalDistance = 8
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.setNavigationBar(self.navigationBar)
    }
    
    override func setupActions() {
        super.setupActions()
        self.changeDirectionBarItem.onClick = { [unowned self] in
            self.collectionColumnsCount = self.collectionScrollDirection == .vertical ? 6 : 2
            self.collectionScrollDirection = self.collectionScrollDirection == .vertical
                ? UICollectionView.ScrollDirection.horizontal
                : UICollectionView.ScrollDirection.vertical
        }
    }
    
    override func setupCell(item: CollectionItem, cell: CollectionViewCell, indexPath: IndexPath) {
        super.setupCell(item: item, cell: cell, indexPath: indexPath)
        cell.cast(item: item, of: DemoCellModel.self, to: DemoCollectionViewCell.self) { (newData, newCell) in
            newCell.fill(newData)
        }
    }
    
    override func selectCell(item: CollectionItem, cell: CollectionViewCell, indexPath: IndexPath) {
        super.selectCell(item: item, cell: cell, indexPath: indexPath)
        cell.cast(item: item, of: DemoCellModel.self, to: DemoCollectionViewCell.self) { [unowned self] (newData, _) in
            UIAlertController()
                .with(title: newData.title)
                .with(message: newData.subtitle)
                .with(action: "Ok")
                .present(on: self)
        }
    }
    
    override func paginationNext() {
        self.startShimmering(self.shimmerDataSource)
        self.provider.loadNextPage()
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        self.shimmerDataSource.reset()
        self.provider.reset()
        self.paginationNext()
    }
}

// MARK: DemoProviderDelegate
extension DemoShimmerPaginationCollectionViewController: DemoProviderDelegate {
    fileprivate func loadItemsPageSuccess(_ page: Page<Int, DemoCellModel>) {
        let items: [CollectionItem] = page.data.map { CollectionItem(of: DemoCollectionViewCell.self, data: $0) }
        self.stopShimmering()
        self.shimmerDataSource.append(items)
        self.paginationSuccess(delay: 0.5, isLast: page.isLast)
        self.pullToRefreshFinish()
    }
    
    fileprivate func loadItemsPageError(_ page: Page<Int, DemoCellModel>) {
        self.stopShimmering()
        Toast.new()
            .with(style: .error)
            .with(title: "Load page error")
            .show(in: self.navigationController)
        self.paginationError(delay: 3.0, isLast: page.isLast)
        self.pullToRefreshFinish()
    }
}

// MARK: DemoProviderDelegate
private protocol DemoProviderDelegate: class {
    func loadItemsPageSuccess(_ page: Page<Int, DemoCellModel>)
    func loadItemsPageError(_ page: Page<Int, DemoCellModel>)
}

// MARK: DemoProvider
private class DemoProvider {
    private var wasError: Bool = false
    private let pagination = Pagination(
        of: DemoCellModel.self,
        firstPageId: 0,
        onNextPageId: { (p, _) in p.lastPageId?.advanced(by: 1) ?? 0 })
    
    private weak var delegate: DemoProviderDelegate?
    
    init(delegate: DemoProviderDelegate) {
        self.delegate = delegate
    }
    
    func reset() {
        self.pagination.reset()
    }
    
    func loadNextPage() {
        let pageId = self.pagination.startLoading()
        self.loadItems(
            pageId: pageId,
            limit: self.pagination.limit,
            error: pageId != 1 || self.wasError ? nil : NSError(),
            success: { [weak self] (items: [DemoCellModel]) in
                guard let `self` = self else { return }
                let page = Page(
                    pageId: pageId,
                    data: items,
                    isLast: pageId == 2)
                self.delegate?.loadItemsPageSuccess(page)
                self.pagination.stopLoading(page)
            }, fail: { [weak self] (error) in
                guard let `self` = self else { return }
                let page = Page(
                    pageId: pageId,
                    data: [DemoCellModel](),
                    error: error)
                self.delegate?.loadItemsPageError(page)
                self.pagination.stopLoading(page)
        })
    }
}

// MARK: DemoProvider - Mock
private extension DemoProvider {
    enum MockType {
        case success
        case fail
        case done
    }
    
    func loadItems(pageId: Int?,
                   limit: Int,
                   error: Error? = nil,
                   success: @escaping ([DemoCellModel]) -> Void,
                   fail: @escaping (Error) -> Void,
                   completion: (([DemoCellModel]?, Error?) -> Void)? = nil) {
        Utils.delay(3.0) {
            if let error: Error = error {
                self.wasError = true
                fail(error)
                completion?(nil, error)
                return
            }
            
            let pageId: Int = pageId.or(0)
            var items: [DemoCellModel] = []
            for i in 0..<limit {
                let item = DemoCellModel(
                    color: UIColor.red.withAlphaComponent(CGFloat.random(in: 0...1)),
                    title: "Some title \(pageId * limit + i + 1)",
                    subtitle: "Some ubtitle",
                    info: LoremIpsum.paragraph(sentences: 2))
                items.append(item)
            }
            success(items)
            completion?(items, nil)
        }
    }
}

// MARK: DemoModel
private struct DemoCellModel {
    let color: UIColor
    let title: String
    let subtitle: String
    let info: String
}

// MARK: DemoCollectionViewCell
private class DemoCollectionViewCell: CollectionViewCell {
    fileprivate let iconView = UIImageView()
        .with(width: 48.0, height: 48.0)
        .rounded()
    fileprivate let titleLabel = Components.label.default()
        .with(color: UIColor.label)
        .with(font: UIFont.systemFont(ofSize: 14))
    fileprivate let subtitleLabel = Components.label.default()
        .with(color: UIColor.darkGray)
        .with(font: UIFont.systemFont(ofSize: 14))
    fileprivate let infoLabel = Components.label.default()
        .with(color: UIColor.gray)
        .with(font: UIFont.systemFont(ofSize: 10))
        .with(numberOfLines: 3)
    
    override func setupView() {
        super.setupView()
        self.contentView.addSubview(self.iconView, with: [
            Anchor.to(self.contentView).top,
            Anchor.to(self.contentView).leading,
            Anchor.to(self.iconView).size(self.iconView.bounds.size)
        ])
        self.contentView.addSubview(self.titleLabel, with: [
            Anchor.to(self.iconView).leadingToTrailing.offset(8),
            Anchor.to(self.contentView).trailing.lessThanOrEqual,
            Anchor.to(self.iconView).bottomToCenterY.offset(1)
        ])
        self.contentView.addSubview(self.subtitleLabel, with: [
            Anchor.to(self.iconView).leadingToTrailing.offset(8),
            Anchor.to(self.contentView).trailing.lessThanOrEqual,
            Anchor.to(self.iconView).topToCenterY.offset(1)
        ])
        self.contentView.addSubview(self.infoLabel, with: [
            Anchor.to(self.iconView).topToBottom.offset(4),
            Anchor.to(self.contentView).leading,
            Anchor.to(self.contentView).trailing
        ])
    }
    
    func fill(_ source: DemoCellModel) {
        self.iconView.image = source.color.image
        self.titleLabel.text = source.title
        self.subtitleLabel.text = source.subtitle
        self.infoLabel.text = source.info
    }
    
    override class func componentHeight(_ source: Any,
                                        _ collectionView: UICollectionView,
                                        _ itemWidth: CGFloat) -> CGFloat? {
        guard let source = source as? DemoCellModel else { return nil }
        let infoHeight: CGFloat = Components.label.default()
            .with(font: UIFont.systemFont(ofSize: 10))
            .with(numberOfLines: 3)
            .with(text: source.info)
            .height(for: itemWidth)
        return 8.0 + 48.0 + 4.0 + infoHeight + 8.0
    }
    
    override class func componentWidth(_ source: Any,
                                       _ collectionView: UICollectionView,
                                       _ itemWidth: CGFloat) -> CGFloat? {
        return 300.0
    }
}

// MARK: DemoCollectionViewCell
private class ShimmerDemoCollectionViewCell: DemoCollectionViewCell {
    override func prepareForShimmering() {
        self.titleLabel.text = LoremIpsum.emptyVeryShort
        self.subtitleLabel.text = LoremIpsum.emptyShort
        self.infoLabel.text = LoremIpsum.emptyMedium
    }
    
    override class func componentHeight(_ source: Any,
                                        _ collectionView: UICollectionView,
                                        _ itemWidth: CGFloat) -> CGFloat {
        let infoHeight: CGFloat = Components.label.default()
            .with(font: UIFont.systemFont(ofSize: 10))
            .with(numberOfLines: 3)
            .with(text: LoremIpsum.emptyMedium)
            .height(for: itemWidth)
        return 8.0 + 48.0 + 4.0 + infoHeight + 8.0
    }
    
    override class func componentWidth(_ source: Any,
                                       _ collectionView: UICollectionView,
                                       _ itemWidth: CGFloat) -> CGFloat? {
        return 300.0
    }
}
