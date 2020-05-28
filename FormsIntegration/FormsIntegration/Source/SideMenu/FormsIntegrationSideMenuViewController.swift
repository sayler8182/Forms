//
//  FormsIntegrationSideMenuViewController.swift
//  FormsIntegration
//
//  Created by Konrad on 4/29/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsSideMenu
import UIKit

// MARK: FormsIntegrationSideMenuViewController
class FormsIntegrationSideMenuViewController: SideMenuController {
    private let leftSide = FormsIntegrationMenuViewController()
    private let content = FormsIntegrationContentViewController()
    
    override func setupContent() {
        super.setupContent()
        self.setLeftSide(self.leftSide.embeded)
        self.setContent(self.content.embeded)
    }
}

// MARK: FormsIntegrationMenuSideViewController
private class FormsIntegrationMenuViewController: FormsTableViewController { }

// MARK: FormsIntegrationContentViewController
private class FormsIntegrationContentViewController: FormsTableViewController {
    private let openButton = Components.button.default()
        .with(title: "Open")
    
    private let divider = Components.utils.divider()
        .with(height: 5)
      
    override func setupContent() {
        super.setupContent()
        self.build([
            self.openButton
        ], divider: self.divider)
    }
     
    override func setupActions() {
        super.setupActions()
        self.openButton.onClick = { [unowned self] in
            self.sideMenuController?.open(direction: .left)
        }
    }
}
