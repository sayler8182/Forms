//
//  DemoNetworkListImageViewController.swift
//  FormsDemo
//
//  Created by Konrad on 6/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsMock
import FormsNetworking
import FormsNetworkingImage
import FormsToastKit
import FormsUtils
import UIKit

// MARK: DemoNetworkListImageViewController
class DemoNetworkListImageViewController: FormsTableViewController {
    private lazy var shimmerDataSource = ShimmerTableDataSource()
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
        self.tableContentInset = UIEdgeInsets(top: 8, bottom: 300)
    }
     
    override func setupCell(row: TableRow, cell: FormsTableViewCell, indexPath: IndexPath) {
        super.setupCell(row: row, cell: cell, indexPath: indexPath)
        cell.cast(row: row, of: DemoCellModel.self, to: DemoTableViewCell.self) { (newData, newCell) in
            newCell.fill(newData)
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
extension DemoNetworkListImageViewController: DemoProviderDelegate {
    fileprivate func loadItemsPageSuccess(_ page: Page<Int, [DemoCellModel]>) {
        let rows: [TableRow] = page.data?.map { TableRow(of: DemoTableViewCell.self, data: $0) } ?? []
        self.stopShimmering()
        self.shimmerDataSource.append(rows)
        self.paginationSuccess(delay: 0.5, isLast: page.isLast)
        self.pullToRefreshFinish()
    }
    
    fileprivate func loadItemsPageError(_ page: Page<Int, [DemoCellModel]>) {
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
    func loadItemsPageSuccess(_ page: Page<Int, [DemoCellModel]>)
    func loadItemsPageError(_ page: Page<Int, [DemoCellModel]>)
}

// MARK: DemoProvider
private class DemoProvider {
    private var wasError: Bool = false
    private let pagination = Pagination(
        of: [DemoCellModel].self,
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
            error: nil,
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
        delay(0.5) {
            if let error: Error = error {
                self.wasError = true
                fail(error)
                completion?(nil, error)
                return
            }
            var items: [DemoCellModel] = []
            let mock = Mock()
            for _ in 0..<limit {
                let item: DemoCellModel = DemoCellModel(
                    image: mock.imageUrl([.quality(.high)]))
                items.append(item)
            }
            success(items)
            completion?(items, nil)
        }
    }
}

// MARK: DemoModel
private struct DemoCellModel {
    let image: URL
}

// MARK: DemoTableViewCell
private class DemoTableViewCell: FormsTableViewCell {
    fileprivate let mainImageView = Components.image.default()
        .with(contentMode: .scaleAspectFill)
    
    override func setupView() {
        super.setupView()
        self.backgroundColor = Theme.Colors.primaryLight
        self.contentView.addSubview(self.mainImageView, with: [
            Anchor.to(self.contentView).vertical,
            Anchor.to(self.contentView).horizontal,
            Anchor.to(self.mainImageView).heightToWidth.multiplier(0.5)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainImageView.cancel()
        self.mainImageView.image = nil
    }
     
    func fill(_ source: DemoCellModel) {
        let request = NetworkImageRequest(
            url: source.image)
            .with(isAutoShimmer: true)
            .with(scaleToFill: self.mainImageView.frame.size)
        self.mainImageView.setImage(request: request)
    }
}

// MARK: DemoTableViewCell
private class ShimmerDemoTableViewCell: DemoTableViewCell {
    override func prepareForShimmering() {
        self.mainImageView.image = nil
    }
}
