//
//  DemoSectionsViewController.swift
//  FormsDemo
//
//  Created by Konrad on 6/10/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoSectionsViewController
class DemoSectionsViewController: FormsTableViewController {
    private let section = Components.section.default()
        .with(text: "Some section")
     
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.section
        ], divider: self.divider)
    }
}
