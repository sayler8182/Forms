//
//  DemoTableViewController.swift
//  FormsDemo
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsUtils
import UIKit

// MARK: DemoTableViewController
class DemoTableViewController: FormsTableViewController {
    private let headerRedView = Components.container.view()
        .with(backgroundColor: Theme.Colors.red)
    private let contentRedView = Components.container.view()
        .with(backgroundColor: Theme.Colors.red)
        .with(height: 44.0)
    private let contentGreenView = Components.container.view()
        .with(backgroundColor: Theme.Colors.green)
        .with(height: 44.0)
    private let contentBlueView = Components.container.view()
        .with(backgroundColor: Theme.Colors.blue)
        .with(height: 44.0)
    private let footerRedView = Components.container.view()
        .with(backgroundColor: Theme.Colors.red)
    private let changeSourceButton = Components.button.default()
        .with(title: "Change source")
    
    private var dataSource: TableDataSource?
    
    override func setupHeader() {
        super.setupHeader()
        self.setHeader(self.headerRedView, height: 44.0)
    }
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.contentRedView,
            self.contentGreenView,
            self.contentBlueView
        ])
        
        DispatchQueue.main.async {
            for i in 0..<2 {
                let color: UIColor = i.isMultiple(of: 2) ? UIColor.systemPink : UIColor.systemGreen
                let view: FormsComponent = Components.container.view()
                    .with(backgroundColor: color)
                self.add(view, animated: .none)
            }
        }
        
        DispatchQueue.main.async {
            for i in 0..<10 {
                let color: UIColor = i.isMultiple(of: 2) ? UIColor.orange : UIColor.yellow
                let view: FormsComponent = Components.container.view()
                    .with(backgroundColor: color)
                self.add(view, animated: .automatic)
            }
        }
    }
    
    override func setupFooter() {
        super.setupFooter()
        self.addToFooter([
            self.footerRedView,
            self.changeSourceButton
        ], height: 44.0)
    }
    
    override func setupActions() {
        super.setupActions()
        self.changeSourceButton.onClick = Unowned(self) { (_self) in
            _self.changeSource()
        }
    }
    
    private func changeSource() {
        guard self.dataSource.isNil else {
            self.dataSource = nil
            self.setDataSource(nil)
            self.reloadData()
            return
        }
        let items: [TableRow] = [
            TableRow(of: DemoTableViewCell.self),
            TableRow(of: DemoTableViewCell.self),
            TableRow(of: DemoTableViewCell.self)
        ]
        let dataSource = TableDataSource()
        self.dataSource = dataSource
        self.setDataSource(self.dataSource)
        dataSource.setItems(items)
    }
}

// MARK: DemoTableViewCell
private class DemoTableViewCell: FormsTableViewCell {
    override func setupView() {
        super.setupView()
        self.backgroundColor = Theme.Colors.green
    }
    
    override class func componentHeight(_ source: Any,
                                        _ tableView: UITableView) -> CGFloat {
        return 44.0
    }
}
