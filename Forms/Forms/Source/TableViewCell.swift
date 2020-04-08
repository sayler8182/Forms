//
//  TableViewCell.swift
//  Forms
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TableViewCell
open class TableViewCell: UITableViewCell, Componentable, ShimmerableTableViewCell {
    open class var identifier: String {
        return "\(self)"
    }
    override public init(style: UITableViewCell.CellStyle,
                         reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    open func componentHeight() -> CGFloat {
        // HOOK
        return UITableView.automaticDimension
    }
    
    open func prepareForShimmering() {
        // HOOK
    }
}

// MARK: DataSource
public extension TableViewCell {
    func cast<D, C: TableViewCell>(data: Any,
                                   of dataType: D.Type,
                                   to cellType: C.Type,
                                   success: (D, C) -> Void) {
        self.cast(
            data: data,
            of: dataType,
            to: cellType,
            success: success,
            fail: { })
    }
    
    func cast<D, C: TableViewCell>(data: Any,
                                   of dataType: D.Type,
                                   to cellType: C.Type,
                                   success: (D, C) -> Void,
                                   fail: () -> Void) {
        guard let data: D = data as? D,
            let cell: C = self as? C else {
                return fail()
        }
        success(data, cell)
    }
}
