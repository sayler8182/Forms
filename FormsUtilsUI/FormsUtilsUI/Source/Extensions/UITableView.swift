//
//  UITableView.swift
//  FormsUtils
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UITableView
public extension UITableView {
    func animated(_ animated: UITableView.RowAnimation,
                  action: () -> Void) {
        animated != .none
            ? action()
            : UIView.performWithoutAnimation(action)
    }
    
    func updateHeaderViewHeight() {
        self.tableHeaderView?.sizeToFit()
    }
    
    func refresh(animated: Bool) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.shouldAnimate(animated) {
            if #available(iOS 11.0, *) {
                self.performBatchUpdates({})
            } else {
                self.beginUpdates()
                self.endUpdates()
            }
        }
    }
}

// MARK: Builder
public extension UITableView {
    func with(alwaysBounceVertical: Bool) -> Self {
        self.alwaysBounceVertical = alwaysBounceVertical
        return self
    }
    func with(contentInset: UIEdgeInsets) -> Self {
        self.contentInset = contentInset
        return self
    }
    func with(separatorStyle: UITableViewCell.SeparatorStyle) -> Self {
        self.separatorStyle = separatorStyle
        return self
    }
}
