//
//  DemoShimmerPaginationTableViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DemoShimmerPaginationTableViewController
class DemoShimmerPaginationTableViewController: TableViewController {
    private lazy var shimmerDataSource = ShimmerDataSource()
        .with(generators: [ShimmerRowGenerator(type: ShimmerDemoTableViewCell.self, count: 3)])
        .with(delegate: self)

    private lazy var provider = DemoProvider(delegate: self)
    
    override func setupConfiguration() {
        super.setupConfiguration()
        self.isBottomToSafeArea = false
        self.paginationIsEnabled = true
        self.paginationOffset = 300
        self.pullToRefreshIsEnabled = true
        self.tableAllowsSelection = true
        self.tableContentInset = UIEdgeInsets(bottom: 300)
    }
     
    override func setupCell(data: TableRowData, cell: TableViewCell, indexPath: IndexPath) {
        super.setupCell(data: data, cell: cell, indexPath: indexPath)
        cell.cast(data: data, of: DemoCellModel.self, to: DemoTableViewCell.self) { (newData, newCell) in
            newCell.fill(newData)
        }
    }
    
    override func selectCell(data: TableRowData, cell: TableViewCell, indexPath: IndexPath) {
        super.selectCell(data: data, cell: cell, indexPath: indexPath)
        cell.cast(data: data, of: DemoCellModel.self, to: DemoTableViewCell.self) { [unowned self] (newData, _) in
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
extension DemoShimmerPaginationTableViewController: DemoProviderDelegate {
    fileprivate func loadItemsPageSuccess(_ page: Page<Int, DemoCellModel>) {
        let rows: [TableRow] = page.data.map { TableRow(of: DemoTableViewCell.self, data: $0) }
        self.stopShimmering()
        self.shimmerDataSource.append(rows)
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
        print("Load \(pageId ?? 0)")
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
                print("Success \(pageId ?? 0)\n")
        }, fail: { [weak self] (error) in
            guard let `self` = self else { return }
            let page = Page(
                pageId: pageId,
                data: [DemoCellModel](),
                error: error)
            self.delegate?.loadItemsPageError(page)
            self.pagination.stopLoading(page)
            print("Error \(pageId ?? 0)\n")
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

// MARK: DemoTableViewCell
private class DemoTableViewCell: TableViewCell {
    fileprivate let iconView = UIImageView()
        .with(width: 48.0, height: 48.0)
        .rounded()
    fileprivate let titleLabel = Components.label.label()
        .with(color: UIColor.label)
        .with(font: UIFont.systemFont(ofSize: 14))
    fileprivate let subtitleLabel = Components.label.label()
        .with(color: UIColor.darkGray)
        .with(font: UIFont.systemFont(ofSize: 14))
    fileprivate let infoLabel = Components.label.label()
        .with(color: UIColor.gray)
        .with(font: UIFont.systemFont(ofSize: 10))
        .with(numberOfLines: 3)
    
    override func setupView() {
        super.setupView()
        self.contentView.addSubview(self.iconView, with: [
            Anchor.to(self.contentView).top.offset(8),
            Anchor.to(self.contentView).leading.offset(16),
            Anchor.to(self.iconView).size(self.iconView.bounds.size)
        ])
        self.contentView.addSubview(self.titleLabel, with: [
            Anchor.to(self.iconView).leadingToTrailing.offset(8),
            Anchor.to(self.contentView).trailing.lessThanOrEqual.offset(16),
            Anchor.to(self.iconView).bottomToCenterY.offset(1)
        ])
        self.contentView.addSubview(self.subtitleLabel, with: [
            Anchor.to(self.iconView).leadingToTrailing.offset(8),
            Anchor.to(self.contentView).trailing.lessThanOrEqual.offset(16),
            Anchor.to(self.iconView).topToCenterY.offset(1)
        ])
        self.contentView.addSubview(self.infoLabel, with: [
            Anchor.to(self.iconView).topToBottom.offset(4),
            Anchor.to(self.contentView).leading.offset(16),
            Anchor.to(self.contentView).trailing.offset(16),
            Anchor.to(self.contentView).bottom.offset(8).priority(.defaultHigh)
        ])
    }
     
    func fill(_ source: DemoCellModel) {
        self.iconView.image = source.color.image
        self.titleLabel.text = source.title
        self.subtitleLabel.text = source.subtitle
        self.infoLabel.text = source.info
    }
}

// MARK: DemoTableViewCell
private class ShimmerDemoTableViewCell: DemoTableViewCell {
    override func prepareForShimmering() {
        self.titleLabel.text = LoremIpsum.emptyVeryShort
        self.subtitleLabel.text = LoremIpsum.emptyShort
        self.infoLabel.text = LoremIpsum.emptyMedium
    }
}
