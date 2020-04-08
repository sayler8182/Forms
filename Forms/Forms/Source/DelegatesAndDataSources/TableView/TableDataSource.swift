//
//  TableDataSource.swift
//  Forms
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TableSection
public struct TableSection {
    public let data: Any
    public let rows: [TableRow]
    
    public init(data: Any = Optional<Any>.none as Any,
                rows: [TableRow]) {
        self.data = data
        self.rows = rows
    }
}

// MARK: TableRow
public typealias TableRowConfigure = ((Any, TableViewCell, IndexPath) -> Void)

public struct TableRow {
    public let data: Any
    public let identifier: String
    public let type: AnyClass
    public let height: CGFloat
    
    public init(data: Any = Optional<Any>.none as Any,
                of type: TableViewCell.Type,
                height: CGFloat = UITableView.automaticDimension) {
        self.data = data
        self.identifier = type.identifier
        self.type = type
        self.height = height
    }
}

// MARK: TableDataSourceProtocol
public protocol TableDataSourceDelegateProtocol {
    func setupCell(data: Any, cell: TableViewCell, indexPath: IndexPath)
}

// MARK: TableDataSource
open class TableDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    private var items: [TableSection]
    public var onConfigure: TableRowConfigure?
    
    override public init() {
        self.items = []
    }
    
    public func setItems(rowType: TableViewCell.Type,
                         data: [Any]) {
        let sectionData: Any = Optional<Any>.none as Any
        var rows: [TableRow] = []
        for rowData in data {
            rows.append(TableRow(data: rowData, of: rowType))
        }
        self.setItems([TableSection(data: sectionData, rows: rows)])
    }
     
    public func setItems(_ items: [TableRow]) {
        self.items = [TableSection(rows: items)]
    }
    
    public func setItems(_ items: [TableSection]) {
        self.items = items
    }
    
    public func prepare(for tableView: UITableView) {
        for section in self.items {
            for row in section.rows {
                tableView.register(row.type, forCellReuseIdentifier: row.identifier)
            }
        }
    }
     
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section: TableSection = self.items[indexPath.section]
        let item: TableRow = section.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath) as! TableViewCell
        cell.stopShimmering()
        self.onConfigure?(item.data, cell, indexPath)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.items[indexPath.section].rows[indexPath.row].height
    }
}

// MARK: Builder
public extension TableDataSource { 
    func with(delegate: TableDataSourceDelegateProtocol?) -> Self {
        self.onConfigure = delegate?.setupCell
        return self
    }
}
