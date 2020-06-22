//
//  UICollectionView.swift
//  FormsUtils
//
//  Created by Konrad on 4/6/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UICollectionView
public extension UICollectionView {
    func animated(_ animated: Bool,
                  action: () -> Void) {
        animated != false
            ? action()
            : UIView.performWithoutAnimation(action)
    }
    
    func flowLayout<T: UICollectionViewFlowLayout>(of type: T.Type) -> T? {
        return self.collectionViewLayout as? T
    }
    
    func refresh(animated: Bool) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.shouldAnimate(animated) {
            self.performBatchUpdates({})
        }
    }
}
