//
//  DemoNavigationBarWithBackOrCloseViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/5/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoNavigationBarWithBackOrCloseViewController
class DemoNavigationBarWithBackOrCloseViewController: FormsTableViewController {
    private lazy var navigationBar = Components.navigationBar.default()
        .with(backImage: { UIImage.from(name: "chevron.compact.left") })
        .with(closeImage: { UIImage.from(name: "xmark.square") })
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.setNavigationBar(self.navigationBar)
    }
}
