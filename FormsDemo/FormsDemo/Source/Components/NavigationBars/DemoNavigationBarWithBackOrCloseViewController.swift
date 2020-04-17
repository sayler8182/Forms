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
class DemoNavigationBarWithBackOrCloseViewController: TableViewController {
    private lazy var navigationBar = Components.navigationBar.navigationBar()
        .with(backImage: { UIImage(systemName: "chevron.compact.left") })
        .with(closeImage: { UIImage(systemName: "xmark.square") })
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.setNavigationBar(self.navigationBar)
    }
}
