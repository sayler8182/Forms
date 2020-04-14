//
//  UIScrollView.swift
//  Utils
//
//  Created by Konrad on 4/10/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public extension UIScrollView {
    @discardableResult
    func shouldLoadNext(offset: CGFloat = 0) -> Bool {
        let contentHeight: CGFloat = self.contentSize.height
        let contentOffset: CGFloat = self.contentOffset.y
        let height: CGFloat = self.frame.size.height
        
        guard contentHeight != 0 else { return true }
        guard contentOffset != 0 else { return false }
        let offsetExceed: Bool = contentOffset + height + offset >= contentHeight
        guard offsetExceed else { return false }
        return true
    }
    
    func scrollToTop(animated: Bool) {
        if let tableView: UITableView = self as? UITableView {
            guard tableView.numberOfSections != 0 else { return }
            guard tableView.numberOfRows(inSection: 0) != 0 else { return }
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: animated)
        } else if let collectionView: UICollectionView = self as? UICollectionView {
            guard collectionView.numberOfSections != 0 else { return }
            guard collectionView.numberOfItems(inSection: 0) != 0 else { return }
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.left, animated: animated)
        } else {
            self.setContentOffset(CGPoint.zero, animated: animated)
        }
    }
    
    func scrollToBottom(animated: Bool) {
        let offset: CGPoint = CGPoint(
            x: 0,
            y: self.contentSize.height - self.bounds.size.height)
        guard offset.y > 0 else { return }
        self.setContentOffset(offset, animated: animated)
    }
}
