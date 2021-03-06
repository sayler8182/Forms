//
//  Shimmer.swift
//  Forms
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsUtils
import UIKit

// MARK: Shimmerable
public protocol Shimmerable: class {
    var isShimmerable: Bool { get set }
    var isShimmering: Bool { get }
    
    func startShimmering(animated: Bool)
    func stopShimmering(animated: Bool)
}
extension Shimmerable {
    func with(isShimmerable: Bool) -> Self {
        self.isShimmerable = isShimmerable
        return self
    }
}
public protocol UnShimmerable: class { }
public class UnShimmerableView: UIView, UnShimmerable { }
public class UnShimmerableLabel: UILabel, UnShimmerable { }
public class UnShimmerableImageView: UIImageView, UnShimmerable { }
public class UnShimmerableButton: UIButton, UnShimmerable { }
extension UISegmentedControl: UnShimmerable { }
extension UIActivityIndicatorView: UnShimmerable { }

// MARK: Shimmer - UIView
public extension UIView {
    private static var isShimmerableKey: UInt8 = 0
    
    var isShimmerable: Bool {
        get { return getObject(self, &Self.isShimmerableKey) ?? true }
        set { setObject(self, &Self.isShimmerableKey, newValue) }
    }
    
    var isShimmering: Bool {
        if self is ShimmerPlaceholderView {
            return true
        }
        for view in self.subviews {
            guard !view.isShimmering else { return true }
        }
        return false
    }
    
    @objc
    func startShimmering(animated: Bool = true) {
        guard self.isShimmerable else { return }
        self.setShimmer(animated: animated)
    }
     
    @objc
    func stopShimmering(animated: Bool = true) {
        self.removeShimmer(animated: animated)
        if self is UnShimmerable { return }
        if self is ShimmerPlaceholderView { return }
    }
    
    private func setShimmer(animated: Bool) {
        let placeholders = self.subviews.filter({ $0 is ShimmerPlaceholderView })
        placeholders.removeFromSuperview()
        if self is UnShimmerable { return }
        if self.shouldPutPlaceholder() {
            self.putPlaceholder(animated: animated)
            return
        }
        for subview in self.subviews {
            subview.startShimmering(animated: animated)
        }
    }
    
    private func removeShimmer(animated: Bool,
                               force: Bool = false) {
        if self is ShimmerPlaceholderView {
            self.animation(
                animated,
                duration: 0.3,
                animations: { self.alpha = 0 },
                completion: { _ in self.removeFromSuperview() })
        }
        for subview in self.subviews {
            subview.stopShimmering(animated: animated)
        }
    }
    
    private func putPlaceholder(animated: Bool) {
        let placeholderView = ShimmerPlaceholderView()
        self.addSubview(placeholderView, with: [
            Anchor.to(self).fill
        ])
        placeholderView.backgroundColor = .clear
        placeholderView.startShimmering(animated: animated)
    }
    
    private func shouldPutPlaceholder() -> Bool {
        guard !self.subviews.isEmpty else { return true }
        let unShimmerableCount: Int = self.subviews.filter { $0 is UnShimmerable || $0.isShimmerable == false }.count
        let allCount: Int = self.subviews.count
        return unShimmerableCount == allCount
    }
}

// MARK: Builder
public extension UIView {
    func with(isShimmerable: Bool) -> Self {
        self.isShimmerable = isShimmerable
        return self
    }
}

// MARK: ShimmerPlaceholderView
private class ShimmerPlaceholderView: UIView {
    private let gradient = CAGradientLayer()
    private let gradientWidth: CGFloat = 0.17
    private let backgroundFadedGray = UIColor(rgbDark: 0x161718, rgbLight: 0xF6F7F8)
    private let gradientFirstStop = UIColor(rgbDark: 0x2D2D2D, rgbLight: 0xEDEDED)
    private let gradientSecondStop = UIColor(rgbDark: 0x3D3D3D, rgbLight: 0xDDDDDD)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradient.frame = self.bounds
    }
    
    override func startShimmering(animated: Bool) {
        self.gradient.startPoint = CGPoint(x: -1.0 + self.gradientWidth, y: 0)
        self.gradient.endPoint = CGPoint(x: 1.0 + self.gradientWidth, y: 0)
        
        self.gradient.colors = [
            self.backgroundFadedGray.cgColor,
            self.gradientFirstStop.cgColor,
            self.gradientSecondStop.cgColor,
            self.gradientFirstStop.cgColor,
            self.backgroundFadedGray.cgColor
        ]
        let startLocations: [NSNumber] = [
            NSNumber(value: Double(self.gradient.startPoint.x)),
            NSNumber(value: Double(self.gradient.startPoint.x)),
            NSNumber(value: Double(0.0)),
            NSNumber(value: Double(self.gradientWidth)),
            NSNumber(value: Double(1.0 + self.gradientWidth))
        ]
        self.gradient.locations = startLocations
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = startLocations
        animation.toValue = [
            NSNumber(value: Double(0.0)),
            NSNumber(value: Double(1.0)),
            NSNumber(value: Double(1.0)),
            NSNumber(value: Double(1.0 + self.gradientWidth - 0.1)),
            NSNumber(value: Double(1.0 + self.gradientWidth))
        ]
        animation.repeatCount = HUGE
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.autoreverses = true
        animation.duration = 2.5
        self.gradient.add(animation, forKey: "locations")
        self.layer.insertSublayer(self.gradient, at: 0)
    }
}

// MARK: ShimmerRowGenerator
public struct ShimmerRowGenerator {
    public let type: FormsTableViewCell.Type
    public let count: Int
    
    public init(type: FormsTableViewCell.Type,
                count: Int = 1) {
        self.type = type
        self.count = count
    }
}

// MARK: ShimmerItemGenerator
public struct ShimmerItemGenerator {
    public let type: FormsCollectionViewCell.Type
    public let count: Int
    
    public init(type: FormsCollectionViewCell.Type,
                count: Int = 1) {
        self.type = type
        self.count = count
    }
}

// MARK: ShimmerDataSource
public protocol ShimmerDataSource {
    func stopShimmering(animated: Bool)
}

// MARK: ShimmerTableDataSource
open class ShimmerTableDataSource: TableDataSource, ShimmerDataSource {
    private var generators: [ShimmerRowGenerator] = []
    
    override public func prepare(for tableView: UITableView,
                                 queue tableUpdatesQueue: DispatchQueue,
                                 scrollDelegate: UIScrollViewDelegate) {
        super.prepare(
            for: tableView,
            queue: tableUpdatesQueue,
            scrollDelegate: scrollDelegate)
    }
    
    public func prepareGenerators() {
        self.append(self.generators)
    }
    
    public func stopShimmering(animated: Bool = true) {
        let sections: [TableSection] = self.sections.filter { $0.isShimmering }
        self.removeFromTable(
            sections,
            animated: animated ? .fade : .none)
    }
    
    private func append(_ generators: [ShimmerRowGenerator]) {
        var sections: [TableSection] = []
        var rows: [TableRow] = []
        for generator in generators {
            for _ in 0..<generator.count {
                let row = TableRow(of: generator.type)
                rows.append(row)
            }
        }
        sections.append(TableSection(isShimmering: true, rows: rows))
        self.append(sections)
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! FormsTableViewCell
        let section: TableSection = self.sections[indexPath.section]
        guard section.isShimmering else { return cell }
        cell.prepareForShimmering()
        cell.startShimmering(animated: true)
        return cell
    }
}

// MARK: ShimmerCollectionDataSource
open class ShimmerCollectionDataSource: CollectionDataSource, ShimmerDataSource {
    private var generators: [ShimmerItemGenerator] = []
    
    override public func prepare(for collectionView: UICollectionView,
                                 queue collectionUpdatesQueue: DispatchQueue,
                                 scrollDelegate: UIScrollViewDelegate) {
        super.prepare(
            for: collectionView,
            queue: collectionUpdatesQueue,
            scrollDelegate: scrollDelegate)
    }
    
    public func prepareGenerators() {
        self.append(self.generators)
    }
    
    public func stopShimmering(animated: Bool) {
        let sections: [CollectionSection] = self.sections.filter { $0.isShimmering }
        self.removeFromCollection(
            sections,
            animated: animated)
    }
    
    private func append(_ generators: [ShimmerItemGenerator]) {
        var sections: [CollectionSection] = []
        var items: [CollectionItem] = []
        for generator in generators {
            for _ in 0..<generator.count {
                let item = CollectionItem(of: generator.type)
                items.append(item)
            }
        }
        sections.append(CollectionSection(isShimmering: true, items: items))
        self.append(sections)
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! FormsCollectionViewCell
        let section: CollectionSection = self.sections[indexPath.section]
        guard section.isShimmering else { return cell }
        cell.prepareForShimmering()
        cell.startShimmering()
        return cell
    }
}

public protocol ShimmerableViewCell: Shimmerable {
    func prepareForShimmering()
}

// MARK: ShimmerTableViewCell
public class ShimmerTableViewCell: FormsTableViewCell {
    private let iconView = UIImageView()
        .with(width: 48.0, height: 48.0)
        .with(image: Theme.Colors.primaryLight.transparent)
        .rounded()
    private let titleLabel = UILabel()
        .with(text: " ")
    private let subtitleLabel = UILabel()
        .with(text: " ")
    
    override public func setupView() {
        super.setupView()
        self.contentView.addSubview(self.iconView, with: [
            Anchor.to(self.contentView).vertical.offset(8),
            Anchor.to(self.contentView).leading.offset(16),
            Anchor.to(self.iconView).size(self.iconView.bounds.size)
        ])
        self.contentView.addSubview(self.titleLabel, with: [
            Anchor.to(self.iconView).leadingToTrailing.offset(8),
            Anchor.to(self.contentView).trailing.offset(16),
            Anchor.to(self.iconView).bottomToCenterY.offset(2)
        ])
        self.contentView.addSubview(self.subtitleLabel, with: [
            Anchor.to(self.iconView).leadingToTrailing.offset(8),
            Anchor.to(self.contentView).trailing.offset(16),
            Anchor.to(self.iconView).topToCenterY.offset(2)
        ])
    }
}

// MARK: ShimmerCollectionViewCell
public class ShimmerCollectionViewCell: FormsCollectionViewCell {
    private let iconView = UIImageView()
        .with(width: 48.0, height: 48.0)
        .with(image: Theme.Colors.primaryLight.transparent)
        .rounded()
    private let titleLabel = UILabel()
        .with(text: " ")
    private let subtitleLabel = UILabel()
        .with(text: " ")
    
    override public func setupView() {
        super.setupView()
        self.contentView.addSubview(self.iconView, with: [
            Anchor.to(self.contentView).vertical.offset(8),
            Anchor.to(self.contentView).leading.offset(16),
            Anchor.to(self.iconView).size(self.iconView.bounds.size)
        ])
        self.contentView.addSubview(self.titleLabel, with: [
            Anchor.to(self.iconView).leadingToTrailing.offset(8),
            Anchor.to(self.contentView).trailing.offset(16),
            Anchor.to(self.iconView).bottomToCenterY.offset(2)
        ])
        self.contentView.addSubview(self.subtitleLabel, with: [
            Anchor.to(self.iconView).leadingToTrailing.offset(8),
            Anchor.to(self.contentView).trailing.offset(16),
            Anchor.to(self.iconView).topToCenterY.offset(2)
        ])
    }
}

// MARK: Builder
public extension ShimmerTableDataSource {
    func with(generators: [ShimmerRowGenerator]) -> Self {
        self.generators = generators
        return self
    }
}

// MARK: Builder
public extension ShimmerCollectionDataSource {
    func with(generators: [ShimmerItemGenerator]) -> Self {
        self.generators = generators
        return self
    }
}
