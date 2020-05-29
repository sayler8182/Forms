//
//  DemoShimmerCollectionViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/24/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsUtils
import UIKit

// MARK: DemoShimmerCollectionViewController
class DemoShimmerCollectionViewController: FormsCollectionViewController {
    private lazy var shimmerDataSource = ShimmerCollectionDataSource()
        .with(generators: [
            ShimmerItemGenerator(type: ShimmerShortDemoCollectionViewCell.self, count: 6),
            ShimmerItemGenerator(type: ShimmerLongDemoCollectionViewCell.self, count: 3)
        ])
        .with(delegate: self)
    
    override func setupContent() {
        super.setupContent()
        self.startShimmering(self.shimmerDataSource)
        delay(2.5, self) { $0.updateDataSource() }
    }
    
    override func setupConfiguration() {
        super.setupConfiguration()
        self.isBottomToSafeArea = false
        self.isTopToSafeArea = false
        self.collectionContentInset = UIEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        self.collectionColumnsCount = 2
        self.collectionColumnsHorizontalDistance = 8
        self.collectionColumnsVerticalDistance = 8
    }
    
    override func setupCell(item: CollectionItem, cell: FormsCollectionViewCell, indexPath: IndexPath) {
        super.setupCell(item: item, cell: cell, indexPath: indexPath)
        cell.cast(item: item, of: DemoCellModel.self, to: DemoCollectionViewCell.self) { (newData, newCell) in
            newCell.fill(newData)
        }
    }
    
    private func updateDataSource() {
        self.updateDataSourceItems()
        self.stopShimmering()
    }
    
    private func updateDataSourceItems() {
        let data: [DemoCellModel] = [
            DemoCellModel(
                color: Theme.Colors.red,
                title: "Red title",
                subtitle: "Red subtitle",
                info: LoremIpsum.paragraph(sentences: 2)),
            DemoCellModel(
                color: Theme.Colors.green,
                title: "Green title",
                subtitle: "Green subtitle",
                info: LoremIpsum.paragraph(sentences: 3)),
            DemoCellModel(
                color: Theme.Colors.blue,
                title: "Blue title",
                subtitle: "Blue subtitle",
                info: LoremIpsum.paragraph(sentences: 4))
        ]
        let items: [CollectionItem] = data.map { CollectionItem(of: DemoCollectionViewCell.self, data: $0) }
        self.shimmerDataSource.setItems(items)
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
private class DemoCollectionViewCell: FormsCollectionViewCell {
    fileprivate let iconView = UIImageView()
        .with(width: 48.0, height: 48.0)
        .rounded()
    fileprivate let titleLabel = Components.label.default()
        .with(color: Theme.Colors.primaryText)
        .with(font: Theme.Fonts.regular(ofSize: 14))
    fileprivate let subtitleLabel = Components.label.default()
        .with(color: UIColor.darkGray)
        .with(font: Theme.Fonts.regular(ofSize: 14))
    fileprivate let infoLabel = Components.label.default()
        .with(color: UIColor.gray)
        .with(font: Theme.Fonts.regular(ofSize: 10))
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
            .with(font: Theme.Fonts.regular(ofSize: 10))
            .with(numberOfLines: 3)
            .with(text: source.info)
            .height(for: itemWidth)
        return 8.0 + 48.0 + 4.0 + infoHeight + 8.0
    }
}

// MARK: DemoCollectionViewCell
private class ShimmerShortDemoCollectionViewCell: DemoCollectionViewCell {
    override func prepareForShimmering() {
        self.titleLabel.text = LoremIpsum.emptyVeryShort
        self.subtitleLabel.text = LoremIpsum.emptyShort
        self.infoLabel.text = LoremIpsum.emptyMedium
    }
    
    override class func componentHeight(_ source: Any,
                                        _ collectionView: UICollectionView,
                                        _ itemWidth: CGFloat) -> CGFloat? {
        let infoHeight: CGFloat = Components.label.default()
            .with(font: Theme.Fonts.regular(ofSize: 10))
            .with(numberOfLines: 3)
            .with(text: LoremIpsum.emptyMedium)
            .height(for: itemWidth)
        return 8.0 + 48.0 + 4.0 + infoHeight + 8.0
    }
}

// MARK: DemoCollectionViewCell
private class ShimmerLongDemoCollectionViewCell: DemoCollectionViewCell {
    override func prepareForShimmering() {
        self.titleLabel.text = LoremIpsum.emptyLong
        self.subtitleLabel.text = LoremIpsum.emptyLong
        self.infoLabel.text = LoremIpsum.empty(lines: 3)
    }
    
    override class func componentHeight(_ source: Any,
                                        _ collectionView: UICollectionView,
                                        _ itemWidth: CGFloat) -> CGFloat? {
        let infoHeight: CGFloat = Components.label.default()
            .with(font: Theme.Fonts.regular(ofSize: 10))
            .with(numberOfLines: 3)
            .with(text: LoremIpsum.empty(lines: 3))
            .height(for: itemWidth)
        return 8.0 + 48.0 + 4.0 + infoHeight + 8.0
    }
}
