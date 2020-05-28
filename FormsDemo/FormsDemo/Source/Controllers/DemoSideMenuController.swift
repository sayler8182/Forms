//
//  DemoSideMenuController.swift
//  FormsDemo
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsSideMenu
import UIKit

// MARK: DemoSideMenuController
class DemoSideMenuController: SideMenuController {
    private let leftSide = DemoMenuViewController()
    private let rightSide = DemoMenuViewController()
    private let content = DemoContentViewController()
    
    override func setupConfiguration() {
        super.setupConfiguration()
        self.rightSideWidth = 200
    }
    
    override func setupContent() {
        super.setupContent()
        self.setLeftSide(self.leftSide.embeded)
        self.setRightSide(self.rightSide.embeded)
        self.setContent(self.content.embeded)
    }
}

// MARK: DemoMenuSideViewController
private class DemoMenuViewController: FormsTableViewController {
    private let closeButton = Components.button.default()
        .with(title: "Close")
    
    private let divider = Components.utils.divider()
        .with(height: 5)
      
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       print("menu viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("menu viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("menu viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("menu viewDidDisappear")
    }
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.closeButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.closeButton.onClick = { [unowned self] in
          self.sideMenuController?.close()
        }
    }
}

// MARK: DemoContentViewController
private class DemoContentViewController: FormsTableViewController {
    private var navigationBar = Components.navigationBar.default()
    private let openLeftButton = Components.button.default()
        .with(title: "Open Left")
    private let openRightButton = Components.button.default()
        .with(title: "Open Right")
    
    private let divider = Components.utils.divider()
        .with(height: 5)
      
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       print("content viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("content viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("content viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("content viewDidDisappear")
    }
    
    override func setupContent() {
        super.setupContent()
        self.build([ 
            self.openLeftButton,
            self.openRightButton
        ], divider: self.divider)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.setNavigationBar(self.navigationBar)
    }
    
    override func setupActions() {
        super.setupActions()
        self.openLeftButton.onClick = { [unowned self] in
            self.sideMenuController?.open(direction: .left)
        }
        self.openRightButton.onClick = { [unowned self] in
            self.sideMenuController?.open(direction: .right)
        }
    }
}
