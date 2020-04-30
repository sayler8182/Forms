//
//  DemoSearchBarViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoSearchBarViewController
class DemoSearchBarViewController: FormsTableViewController {
    private let searchBar = Components.input.searchBar.default()
        .with(placeholder: "Text")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    private lazy var searchController = FormsSearchController()
    
    override func setupConfiguration() {
        super.setupConfiguration()
        self.tableAlwaysBounceVertical = true
    }
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.searchBar
        ], divider: self.divider)
    }
    
    override func setupSearchBar() {
        super.setupSearchBar()
        self.setSearchBar(self.searchController)
    }
}
