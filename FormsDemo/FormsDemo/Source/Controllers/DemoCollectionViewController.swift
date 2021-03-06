//
//  DemoCollectionViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/24/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoCollectionViewController
class DemoCollectionViewController: FormsCollectionViewController {
    private let headerRedView = Components.container.view()
        .with(backgroundColor: Theme.Colors.red)
    private let footerRedView = Components.container.view()
        .with(backgroundColor: Theme.Colors.red)
    private let footerGreenView = Components.container.view()
        .with(backgroundColor: Theme.Colors.green)
    
    private var dataSource = CollectionDataSource()
    
    override func setupConfiguration() {
        super.setupConfiguration()
        self.collectionContentInset = UIEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        self.collectionColumnsCount = 2
        self.collectionColumnsHorizontalDistance = 8
        self.collectionColumnsVerticalDistance = 8
    }
    
    override func setupHeader() {
        super.setupHeader()
        self.setHeader(self.headerRedView, height: 44.0)
    }
    
    override func setupContent() {
        super.setupContent()
        let items: [CollectionItem] = [
            CollectionItem(of: DemoCollectionViewCell.self),
            CollectionItem(of: DemoCollectionViewCell.self),
            CollectionItem(of: DemoCollectionViewCell.self),
            CollectionItem(of: DemoCollectionViewCell.self),
            CollectionItem(of: DemoCollectionViewCell.self),
            CollectionItem(of: DemoCollectionViewCell.self),
            CollectionItem(of: DemoCollectionViewCell.self),
            CollectionItem(of: DemoCollectionViewCell.self),
            CollectionItem(of: DemoCollectionViewCell.self)
        ]
        self.setDataSource(self.dataSource)
        self.dataSource.setItems(items)
    }
    
    override func setupFooter() {
        super.setupFooter()
        self.addToFooter([
            self.footerRedView,
            self.footerGreenView
        ], height: 44.0)
    }
}

// MARK: DemoCollectionViewCell
private class DemoCollectionViewCell: FormsCollectionViewCell {
    override func setupView() {
        super.setupView()
        self.backgroundColor = Theme.Colors.green
    }
    
    override class func componentHeight(_ source: Any,
                                        _ collectionView: UICollectionView,
                                        _ itemWidth: CGFloat) -> CGFloat {
        return 100.0
    }
}
