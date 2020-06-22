//
//  FormsCollectionViewCell.swift
//  Forms
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: FormsCollectionViewCell
open class FormsCollectionViewCell: UICollectionViewCell, Componentable, ShimmerableViewCell {
    open class var identifier: String {
        return "\(self)"
    }
    
    public weak var collectionView: UICollectionView?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    open func setupView() {
        self.setupActions()
        self.setTheme()
        self.setLanguage()
        self.setupMock()
    }
    
    // MARK: HOOKS
    open func setupActions() {
        // HOOK
    }
    
    open func setTheme() {
        // HOOK
    }
    
    open func setLanguage() {
        // HOOK
    }
    
    open func prepareForShimmering() {
        // HOOK
    }
    
    open class func componentHeight(_ source: Any,
                                    _ collectionView: UICollectionView,
                                    _ itemWidth: CGFloat) -> CGFloat? {
        // HOOK
        return nil
    }
    
    open class func componentWidth(_ source: Any,
                                   _ collectionView: UICollectionView,
                                   _ itemHeight: CGFloat) -> CGFloat? {
        // HOOK
        return nil
    }
    
    @objc
    open dynamic func setupMock() {
        // HOOK
    }
}

// MARK: DataSource
public extension FormsCollectionViewCell {
    func cast<D, C: FormsCollectionViewCell>(item: CollectionItem,
                                             of dataType: D.Type,
                                             to cellType: C.Type,
                                             success: (D, C) -> Void) {
        self.cast(
            item: item,
            of: dataType,
            to: cellType,
            success: success,
            fail: { })
    }
    
    func cast<D, C: FormsCollectionViewCell>(item: CollectionItem,
                                             of dataType: D.Type,
                                             to cellType: C.Type,
                                             success: (D, C) -> Void,
                                             fail: () -> Void) {
        guard let data: D = item.data as? D,
            let cell: C = self as? C else {
                return fail()
        }
        success(data, cell)
    }
}
