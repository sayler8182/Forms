//
//  TableDataSource.swift
//  Forms
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TableSection
public class TableSection {
    public let type: FormsComponent.Type?
    public let isShimmering: Bool
    public let data: Any
    public fileprivate (set) var rows: [TableRow]
    
    public init(of type: FormsComponent.Type? = nil,
                isShimmering: Bool = false,
                data: Any = TableDataSource.Empty,
                rows: [TableRow]) {
        self.type = type
        self.isShimmering = isShimmering
        self.data = data
        self.rows = rows
    }
}

// MARK: TableRow
public typealias TableRowConfigure = ((TableRow, FormsTableViewCell, IndexPath) -> Void)
 
public class TableRow {
    public let type: AnyClass
    public let data: Any
    public let identifier: String
    
    public init(of type: FormsTableViewCell.Type,
                data: Any = TableDataSource.Empty) {
        self.data = data
        self.type = type
        self.identifier = type.identifier
    }
}

// MARK: TableDataSourceProtocol
public protocol TableDataSourceDelegateProtocol: class {
    func setupSection(section: TableSection, view: FormsComponent, index: Int)
    func setupCell(row: TableRow, cell: FormsTableViewCell, indexPath: IndexPath)
    func selectCell(row: TableRow, cell: FormsTableViewCell, indexPath: IndexPath)
}

// MARK: TableDataSource
open class TableDataSource: NSObject {
    public static var Empty = ((Optional<Any>.none) as Any)
    
    public private (set) var sections: [TableSection]
    private weak var tableView: UITableView? 
    private var tableUpdatesQueue: DispatchQueue = .main
    private weak var scrollDelegate: UIScrollViewDelegate?
    private weak var delegate: TableDataSourceDelegateProtocol?
    
    override public init() {
        self.sections = []
    }
    
    public func reset(animated: Bool = true) {
        let sections: [TableSection] = []
        self.setItems(sections, animated: animated)
    }
    
    public func prepare(for tableView: UITableView) {
        self.tableView = tableView
    }
                        
    public func prepare(for tableView: UITableView,
                        queue tableUpdatesQueue: DispatchQueue,
                        scrollDelegate: UIScrollViewDelegate) {
        self.tableView = tableView
        self.tableUpdatesQueue = tableUpdatesQueue
        self.scrollDelegate = scrollDelegate
    }
    
    public func prepareDataSource(_ sections: [TableSection]) {
        let rows: [TableRow] = sections.flatMap { $0.rows }
        self.prepareDataSource(rows)
    }
    
    public func prepareDataSource(_ rows: [TableRow]) {
        guard let tableView = self.tableView else { return }
        for row in rows {
            tableView.register(row.type, forCellReuseIdentifier: row.identifier)
        }
    }
    
    public func setItems(_ sections: [TableSection],
                         animated: Bool = true) {
        guard let tableView = self.tableView else { return }
        self.prepareDataSource(sections)
        self.sections = sections
        self.tableUpdatesQueue.async {
            tableView.transition(
                animated,
                duration: 0.3,
                animations: tableView.reloadData)
        }
    }
    
    public func setItems(_ rows: [TableRow],
                         animated: Bool = true) {
        let section = TableSection(
            data: TableDataSource.Empty,
            rows: rows)
        self.setItems([section], animated: animated)
    }
    
    public func appendAsync(_ sections: [TableSection],
                            animated: UITableView.RowAnimation = .top) {
        DispatchQueue.main.async {
            self.append(sections, animated: animated)
        }
    }
    
    public func append(_ sections: [TableSection],
                       animated: UITableView.RowAnimation = .none) {
        self.prepareDataSource(sections)
        self.appendToTable(sections, animated: animated)
    }
    
    public func appendAsync(_ rows: [TableRow],
                            animated: UITableView.RowAnimation = .top) {
        DispatchQueue.main.async {
            self.append(rows, animated: animated)
        }
    }
        
    public func append(_ rows: [TableRow],
                       animated: UITableView.RowAnimation = .top) {
        let sections: [TableSection] = self.sections.filter { !$0.isShimmering }
        if sections.isNotEmpty {
            self.prepareDataSource(rows)
            self.appendToTable(rows, animated: animated)
        } else {
            let section = TableSection(rows: rows)
            self.append([section], animated: animated)
        }
    }
}

// MARK: Updates
extension TableDataSource {
    internal func removeFromTable(_ sections: [TableSection],
                                  animated: UITableView.RowAnimation) {
        guard let tableView = self.tableView else { return }
        guard sections.isNotEmpty else { return }
        self.tableUpdatesQueue.async {
            tableView.animated(animated) {
                self.sections = self.sections.filter { (section) in !sections.contains(where: { $0 === section }) }
                tableView.transition(
                    animated != .none,
                    duration: 0.3,
                    animations: tableView.reloadData)
            }
        }
    }
    
    internal func appendToTable(_ sections: [TableSection],
                                animated: UITableView.RowAnimation) {
        guard let tableView = self.tableView else { return }
        guard sections.isNotEmpty else { return }
        self.tableUpdatesQueue.async {
            tableView.animated(animated) {
                if !self.sections.isEmpty {
                    let startIndex: Int = self.sections.count
                    let endIndex: Int = startIndex.advanced(by: sections.count)
                    let set: IndexSet = IndexSet(startIndex..<endIndex)
                    self.sections.append(contentsOf: sections)
                    if #available(iOS 11.0, *) {
                        tableView.performBatchUpdates({
                            tableView.insertSections(set, with: animated)
                        })
                    } else {
                        tableView.beginUpdates()
                        tableView.insertSections(set, with: animated)
                        tableView.endUpdates()
                    }
                } else {
                    self.sections.append(contentsOf: sections)
                    tableView.transition(
                        animated != .none,
                        duration: 0.3,
                        animations: tableView.reloadData)
                }
            }
        }
    }
    
    internal func appendToTable(_ rows: [TableRow],
                                animated: UITableView.RowAnimation) {
        guard let tableView = self.tableView else { return }
        guard rows.isNotEmpty else { return }
        self.tableUpdatesQueue.async {
            tableView.animated(animated) {
                let sectionIndex: Int = self.sections.count - 1
                self.sections[sectionIndex].rows.append(contentsOf: rows)
                tableView.reloadData()
            }
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension TableDataSource: UITableViewDelegate, UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rows.count
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section: TableSection = self.sections[indexPath.section]
        guard !section.isShimmering else { return }
        let row: TableRow = section.rows[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! FormsTableViewCell
        self.delegate?.selectCell(row: row, cell: cell, indexPath: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let index: Int = section
        let section: TableSection = self.sections[index]
        guard let type = section.type else { return nil }
        let component: FormsComponent = type.init()
        component.translatesAutoresizingMaskIntoConstraints = true
        self.tableUpdatesQueue.async {
            self.delegate?.setupSection(section: section, view: component, index: index)
        }
        return component
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section: TableSection = self.sections[indexPath.section]
        let row: TableRow = section.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.identifier, for: indexPath) as! FormsTableViewCell
        cell.tableView = tableView
        cell.selectionStyle = .none
        cell.stopShimmering()
        self.tableUpdatesQueue.async {
            self.delegate?.setupCell(row: row, cell: cell, indexPath: indexPath)
        }
        return cell
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section: TableSection = self.sections[section]
        guard let type = section.type else { return CGFloat.leastNormalMagnitude }
        return type.componentHeight(section.data, tableView)
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section: TableSection = self.sections[indexPath.section]
        let row: TableRow = section.rows[indexPath.row]
        guard let type = row.type as? FormsTableViewCell.Type else { return UITableView.automaticDimension }
        return type.componentHeight(row.data, tableView)
    }
}

// MARK: UIScrollViewDelegate
public extension TableDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollDelegate?.scrollViewDidScroll?(scrollView)
    }
}

// MARK: Builder
public extension TableDataSource { 
    func with(delegate: TableDataSourceDelegateProtocol?) -> Self {
        self.delegate = delegate
        return self
    }
}
