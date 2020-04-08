//
//  Shimmer.swift
//  Forms
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: Shimmerable
public protocol Shimmerable: class {
    func startShimmering()
    func stopShimmering()
}
public protocol UnShimmerable: class { }
public class UnShimmerableLabel: UILabel, UnShimmerable { }
public class UnShimmerableImageView: UIImageView, UnShimmerable { }
public class UnShimmerableButton: UIButton, UnShimmerable { }

// MARK: Shimmer - UIView
public extension UIView {
    @objc
    func startShimmering() {
        self.setShimmer(in: self)
    }
    
    @objc
    func stopShimmering() {
        self.removeShimmer(from: self)
        if self is UnShimmerable { return }
        if self is ShimmerPlaceholderView { return }
        self.isUserInteractionEnabled = true
    }
    
    private func setShimmer(in view: UIView) {
        if view.subviews.count == 0 {
            if view is UnShimmerable { return }
            if view is ShimmerPlaceholderView { return }
            self.putPlaceholder(in: view)
            self.isUserInteractionEnabled = true
        }
        for subview in self.subviews {
            subview.startShimmering()
        }
    }
    
    private func removeShimmer(from view: UIView) {
        if view is ShimmerPlaceholderView {
            view.removeFromSuperview()
        }
        for subview in view.subviews {
            subview.stopShimmering()
        }
    }
    
    private func putPlaceholder(in view: UIView) {
        let placeholderView = ShimmerPlaceholderView()
        view.addSubview(placeholderView, with: [
            Anchor.to(view).fill
        ])
        placeholderView.backgroundColor = .lightGray
        placeholderView.startShimmering()
    }
}

// MARK: ShimmerPlaceholderView
private class ShimmerPlaceholderView: UIView {
    private let gradient = CAGradientLayer()
    private let gradientWidth: CGFloat = 0.17
    private let backgroundFadedGray = UIColor(0xF6F7F8)
    private let gradientFirstStop = UIColor(0xEDEDED)
    private let gradientSecondStop = UIColor(0xDDDDDD)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradient.frame = self.bounds
    }
    
    override func startShimmering() {
        self.gradient.startPoint = CGPoint(x: -1.0 + self.gradientWidth, y: 0)
        self.gradient.endPoint = CGPoint(x: 1.0 + self.gradientWidth, y: 0)
        
        self.gradient.colors = [
            self.backgroundFadedGray.cgColor,
            self.gradientFirstStop.cgColor,
            self.gradientSecondStop.cgColor,
            self.gradientFirstStop.cgColor,
            self.backgroundFadedGray.cgColor,
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
            NSNumber(value: Double(1.0 + self.gradientWidth)),
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
    public let type: TableViewCell.Type
    public let count: Int
    
    public init(type: TableViewCell.Type,
                count: Int = 1) {
        self.type = type
        self.count = count
    }
}

// MARK: ShimmerDataSource
open class ShimmerDataSource: TableDataSource {
    public func setItems(rowType: TableViewCell.Type,
                         count: Int) {
        let data: [Any] = [Any](repeating: Optional<Any>.none as Any, count: count)
        self.setItems(rowType: rowType, data: [data])
    }
    
    public func setItems(generators: [ShimmerRowGenerator]) {
        let data: Any = Optional<Any>.none as Any
        var rows: [TableRow] = []
        for generator in generators {
            for _ in 0..<generator.count {
                rows.append(TableRow(data: data, of: generator.type))
            }
        }
        self.setItems([TableSection(data: data, rows: rows)])
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! TableViewCell
        cell.prepareForShimmering()
        cell.startShimmering()
        return cell
    }
}

public protocol ShimmerableTableViewCell: Shimmerable {
    func prepareForShimmering()
}

// MARK: ShimmerTableViewCell
public class ShimmerTableViewCell: TableViewCell {
    private let iconView = UIImageView()
        .with(width: 48.0, height: 48.0)
        .with(image: UIColor.white.transparent)
        .rounded()
    private let titleLabel = UILabel()
        .with(text: " ")
    private let subtitleLabel = UILabel()
        .with(text: " ")
    
    public override func setupView() {
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
public extension ShimmerDataSource {
    func with(rowType: TableViewCell.Type,
              count: Int) -> Self {
        self.setItems(rowType: rowType, count: count)
        return self
    }
    func with(generators: [ShimmerRowGenerator]) -> Self {
        self.setItems(generators: generators)
        return self
    }
}
