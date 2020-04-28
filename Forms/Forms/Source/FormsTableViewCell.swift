//
//  FormsTableViewCell.swift
//  Forms
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: FormsTableViewCell
open class FormsTableViewCell: UITableViewCell, Componentable, ShimmerableViewCell {
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
    
    open func prepareForShimmering() {
        // HOOK
    }
    
    open class func componentHeight(_ source: Any,
                                    _ tableView: UITableView) -> CGFloat {
        // HOOK
        return UITableView.automaticDimension
    }
}

// MARK: DataSource
public extension FormsTableViewCell {
    func cast<D, C: FormsTableViewCell>(row: TableRow,
                                        of dataType: D.Type,
                                        to cellType: C.Type,
                                        success: (D, C) -> Void) {
        self.cast(
            row: row,
            of: dataType,
            to: cellType,
            success: success,
            fail: { })
    }
    
    func cast<D, C: FormsTableViewCell>(row: TableRow,
                                        of dataType: D.Type,
                                        to cellType: C.Type,
                                        success: (D, C) -> Void,
                                        fail: () -> Void) {
        guard let data: D = row.data as? D,
            let cell: C = self as? C else {
                return fail()
        }
        success(data, cell)
    }
}
