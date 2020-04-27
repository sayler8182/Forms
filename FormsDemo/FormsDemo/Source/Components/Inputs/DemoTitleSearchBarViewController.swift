//
//  DemoTitleSearchBarViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoTitleSearchBarViewController
class DemoTitleSearchBarViewController: TableViewController {
    private let searchBar = Components.input.searchBar.default()
        .with(placeholder: "Text")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.searchBar
        ], divider: self.divider)
    }
}
