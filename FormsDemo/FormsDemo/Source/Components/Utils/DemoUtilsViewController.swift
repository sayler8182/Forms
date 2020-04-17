//
//  DemoUtilsViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoUtilsViewController
class DemoUtilsViewController: TableViewController {
    private let customDivider = Components.utils.divider()
        .with(color: UIColor.red)
        .with(height: 44)
     
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.customDivider
        ], divider: self.divider)
    }
}
