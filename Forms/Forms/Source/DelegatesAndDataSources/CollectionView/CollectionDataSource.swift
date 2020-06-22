//
//  CollectionDataSource.swift
//  Forms
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: CollectionSection
public class CollectionSection {
    public let isShimmering: Bool
    public let data: Any
    public fileprivate (set) var items: [CollectionItem]
    
    public init(isShimmering: Bool = false,
                data: Any = CollectionDataSource.Empty,
                items: [CollectionItem]) {
        self.isShimmering = isShimmering
        self.data = data
        self.items = items
    }
}

// MARK: CollectionItem
public typealias CollectionItemConfigure = ((CollectionItem, FormsCollectionViewCell, IndexPath) -> Void)
 
public class CollectionItem {
    public let type: AnyClass
    public let data: Any
    public let identifier: String
    
    public init(of type: FormsCollectionViewCell.Type,
                data: Any = CollectionDataSource.Empty) {
        self.data = data
        self.type = type
        self.identifier = type.identifier
    }
}

// MARK: CollectionDataSourceProtocol
public protocol CollectionDataSourceDelegateProtocol: class {
    func setupCell(item: CollectionItem, cell: FormsCollectionViewCell, indexPath: IndexPath)
    func selectCell(item: CollectionItem, cell: FormsCollectionViewCell, indexPath: IndexPath)
}

// MARK: CollectionDataSource
open class CollectionDataSource: NSObject {
    public static var Empty = ((Optional<Any>.none) as Any)
    
    public private (set) var sections: [CollectionSection]
    private weak var collectionView: UICollectionView?
    private var collectionUpdatesQueue: DispatchQueue = .main
    private weak var scrollDelegate: UIScrollViewDelegate?
    private weak var delegate: CollectionDataSourceDelegateProtocol?
    
    override public init() {
        self.sections = []
    }
    
    public func reset(animated: Bool = true) {
        let sections: [CollectionSection] = []
        self.setItems(sections, animated: animated)
    }
    
    public func prepare(for collectionView: UICollectionView,
                        queue collectionUpdatesQueue: DispatchQueue,
                        scrollDelegate: UIScrollViewDelegate) {
        self.collectionView = collectionView
        self.collectionUpdatesQueue = collectionUpdatesQueue
        self.scrollDelegate = scrollDelegate
    }
    
    public func prepareDataSource(_ sections: [CollectionSection]) {
        let items: [CollectionItem] = sections.flatMap { $0.items }
        self.prepareDataSource(items)
    }
    
    public func prepareDataSource(_ items: [CollectionItem]) {
        guard let collectionView = self.collectionView else { return }
        for item in items {
            collectionView.register(item.type, forCellWithReuseIdentifier: item.identifier)
        }
    }
    
    public func setItems(_ sections: [CollectionSection],
                         animated: Bool = true) {
        guard let collectionView = self.collectionView else { return }
        self.prepareDataSource(sections)
        self.sections = sections
        collectionView.transition(
            animated,
            duration: 0.3,
            animations: collectionView.reloadData)
    }
    
    public func setItems(_ items: [CollectionItem],
                         animated: Bool = true) {
        let section = CollectionSection(
            data: CollectionDataSource.Empty,
            items: items)
        self.setItems([section], animated: animated)
    }
    
    public func append(_ sections: [CollectionSection],
                       animated: Bool = false) {
        self.prepareDataSource(sections)
        self.appendToCollection(sections, animated: animated)
    }
    
    public func append(_ items: [CollectionItem],
                       animated: Bool = true) {
        let sections: [CollectionSection] = self.sections.filter { !$0.isShimmering }
        if sections.isNotEmpty {
            self.prepareDataSource(items)
            self.appendToCollection(items, animated: animated)
        } else {
            let section = CollectionSection(items: items)
            self.append([section], animated: animated)
        }
    }
}

// MARK: Updates
extension CollectionDataSource {
    internal func removeFromCollection(_ sections: [CollectionSection],
                                       animated: Bool) {
        guard let collectionView = self.collectionView else { return }
        guard sections.isNotEmpty else { return }
        self.collectionUpdatesQueue.async {
            collectionView.animated(animated) {
                self.sections = self.sections.filter { (section) in !sections.contains(where: { $0 === section }) }
                collectionView.transition(
                    animated,
                    duration: 0.3,
                    animations: collectionView.reloadData)
            }
        }
    }
    
    internal func appendToCollection(_ sections: [CollectionSection],
                                     animated: Bool) {
        guard let collectionView = self.collectionView else { return }
        guard sections.isNotEmpty else { return }
        self.collectionUpdatesQueue.async {
            collectionView.animated(animated) {
                if !self.sections.isEmpty {
                    let startIndex: Int = self.sections.count
                    let endIndex: Int = startIndex.advanced(by: sections.count)
                    let set: IndexSet = IndexSet(startIndex..<endIndex)
                    self.sections.append(contentsOf: sections)
                    collectionView.performBatchUpdates({
                        collectionView.insertSections(set)
                    })
                } else {
                    self.sections.append(contentsOf: sections)
                    collectionView.transition(
                        animated,
                        duration: 0.3,
                        animations: collectionView.reloadData)
                }
            }
        }
    }
    
    internal func appendToCollection(_ items: [CollectionItem],
                                     animated: Bool) {
        guard let collectionView = self.collectionView else { return }
        guard items.isNotEmpty else { return }
        self.collectionUpdatesQueue.async {
            collectionView.animated(animated) {
                let sectionIndex: Int = self.sections.count - 1
                self.sections[sectionIndex].items.append(contentsOf: items)
                collectionView.reloadData()
            }
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CollectionDataSource: UICollectionViewDelegate, UICollectionViewDataSource, CollectionDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section: CollectionSection = self.sections[indexPath.section]
        guard !section.isShimmering else { return }
        let item: CollectionItem = section.items[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as! FormsCollectionViewCell
        cell.collectionView = collectionView
        cell.stopShimmering()
        self.delegate?.selectCell(item: item, cell: cell, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section: CollectionSection = self.sections[indexPath.section]
        let item: CollectionItem = section.items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.identifier, for: indexPath) as! FormsCollectionViewCell
        cell.stopShimmering()
        self.delegate?.setupCell(item: item, cell: cell, indexPath: indexPath)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat? {
        let section: CollectionSection = self.sections[indexPath.section]
        let item: CollectionItem = section.items[indexPath.item]
        guard let type = item.type as? FormsCollectionViewCell.Type,
            let flowLayout = collectionView.flowLayout(of: CollectionFlowLayout.self) else { return 44.0 }
        return type.componentHeight(item.data, collectionView, flowLayout.itemWidth)
    }
    
    public func collectionView(_ collectionView: UICollectionView, widthForItemAt indexPath: IndexPath) -> CGFloat? {
        let section: CollectionSection = self.sections[indexPath.section]
        let item: CollectionItem = section.items[indexPath.item]
        guard let type = item.type as? FormsCollectionViewCell.Type,
        let flowLayout = collectionView.flowLayout(of: CollectionFlowLayout.self) else { return 44.0 }
        return type.componentWidth(item.data, collectionView, flowLayout.itemHeight)
    }
}

// MARK: UIScrollViewDelegate
public extension CollectionDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollDelegate?.scrollViewDidScroll?(scrollView)
    }
}

// MARK: Builder
public extension CollectionDataSource {
    func with(delegate: CollectionDataSourceDelegateProtocol?) -> Self {
        self.delegate = delegate
        return self
    }
}
