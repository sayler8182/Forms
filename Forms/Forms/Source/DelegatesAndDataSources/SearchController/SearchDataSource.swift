//
//  SearchDataSource.swift
//  Forms
//
//  Created by Konrad on 4/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: SearchUpdater
public protocol SearchUpdater: UISearchResultsUpdating {
    var searchController: UISearchController? { get set }
}

// MARK: SearchDataSource
open class SearchDataSource<T>: NSObject, SearchUpdater {
    private var originalItems: [T] = []
    private var filteredItems: [T] = []
    
    public weak var tableView: UITableView?
    public weak var searchController: UISearchController?
    
    open var items: [T] {
        get { return self.filteredItems }
        set {
            self.originalItems = newValue
            self.filter(for: self.searchController)
        }
    }
    
    open var onFilter: (([T], String) -> [T])? = nil
    
    public init(_ controller: FormsTableViewController?) {
        super.init()
        self.tableView = controller?.tableView
    }
    
    public init(_ tableView: UITableView?) {
        super.init()
        self.tableView = tableView
    }
    
    private func filter(for searchController: UISearchController?) {
        let query: String = searchController?.searchBar.text ?? ""
        if !query.isEmpty {
            let filteredItems: [T] = self.onFilter?(self.originalItems, query) ?? []
            self.filteredItems = filteredItems
            self.tableView?.reloadData()
        } else {
            self.filteredItems = self.originalItems
            self.tableView?.reloadData()
        }
    }
    
    // MARK: SearchUpdater
    public func updateSearchResults(for searchController: UISearchController) {
        self.filter(for: searchController)
    }
}
