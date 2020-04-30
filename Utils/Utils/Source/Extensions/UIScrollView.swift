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
    
    @discardableResult
    func shouldLoadNext(offset: CGFloat = 0,
                        scrollDirection: UICollectionView.ScrollDirection) -> Bool {
        switch scrollDirection {
        case .vertical:
            let contentHeight: CGFloat = self.contentSize.height
            let contentOffset: CGFloat = self.contentOffset.y
            let height: CGFloat = self.frame.size.height
            guard contentHeight != 0 else { return true }
            guard contentOffset != 0 else { return false }
            let offsetExceed: Bool = contentOffset + height + offset >= contentHeight
            guard offsetExceed else { return false }
            return true
        case .horizontal:
            let contentWidth: CGFloat = self.contentSize.width
            let contentOffset: CGFloat = self.contentOffset.x
            let width: CGFloat = self.frame.size.width
            guard contentWidth != 0 else { return true }
            guard contentOffset != 0 else { return false }
            let offsetExceed: Bool = contentOffset + width + offset >= contentWidth
            guard offsetExceed else { return false }
            return true
        default:
            return false
        }
    }
    
    func scrollToTop(animated: Bool) {
        if let tableView: UITableView = self as? UITableView,
            tableView.numberOfSections != 0,
            tableView.numberOfRows(inSection: 0) != 0 {
            self.setContentOffset(CGPoint.zero, animated: animated)
        } else if let collectionView: UICollectionView = self as? UICollectionView,
            collectionView.numberOfSections != 0,
            collectionView.numberOfItems(inSection: 0) != 0 {
            self.setContentOffset(CGPoint.zero, animated: animated)
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
