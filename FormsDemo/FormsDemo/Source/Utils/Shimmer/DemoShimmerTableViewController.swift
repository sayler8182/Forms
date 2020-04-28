//
//  DemoShimmerTableViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoShimmerTableViewController
class DemoShimmerTableViewController: FormsTableViewController {
    private lazy var shimmerDataSource = ShimmerTableDataSource()
        .with(generators: [
            ShimmerRowGenerator(type: ShimmerShortDemoTableViewCell.self, count: 6),
            ShimmerRowGenerator(type: ShimmerLongDemoTableViewCell.self, count: 3)
        ])
        .with(delegate: self)
    
    override func setupContent() {
        super.setupContent()
        self.startShimmering(self.shimmerDataSource)
        Utils.delay(2.5, self) { $0.updateDataSource() }
    }
    
    override func setupConfiguration() {
        super.setupConfiguration()
        self.isBottomToSafeArea = false
        self.isTopToSafeArea = false
    }
    
    override func setupCell(row: TableRow, cell: FormsTableViewCell, indexPath: IndexPath) {
        super.setupCell(row: row, cell: cell, indexPath: indexPath)
        cell.cast(row: row, of: DemoCellModel.self, to: DemoTableViewCell.self) { (newData, newCell) in
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
                color: UIColor.red,
                title: "Red title",
                subtitle: "Red subtitle",
                info: LoremIpsum.paragraph(sentences: 2)),
            DemoCellModel(
                color: UIColor.green,
                title: "Green title",
                subtitle: "Green subtitle",
                info: LoremIpsum.paragraph(sentences: 3)),
            DemoCellModel(
                color: UIColor.blue,
                title: "Blue title",
                subtitle: "Blue subtitle",
                info: LoremIpsum.paragraph(sentences: 4))
        ]
        let rows: [TableRow] = data.map { TableRow(of: DemoTableViewCell.self, data: $0) }
        self.shimmerDataSource.setItems(rows)
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
private class DemoTableViewCell: FormsTableViewCell {
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
            Anchor.to(self.contentView).bottom.offset(8)
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
private class ShimmerShortDemoTableViewCell: DemoTableViewCell {
    override func prepareForShimmering() {
        self.titleLabel.text = LoremIpsum.emptyVeryShort
        self.subtitleLabel.text = LoremIpsum.emptyShort
        self.infoLabel.text = LoremIpsum.emptyMedium
    }
}

// MARK: DemoTableViewCell
private class ShimmerLongDemoTableViewCell: DemoTableViewCell {
    override func prepareForShimmering() {
        self.titleLabel.text = LoremIpsum.emptyLong
        self.subtitleLabel.text = LoremIpsum.emptyLong
        self.infoLabel.text = LoremIpsum.empty(lines: 3)
    }
}
