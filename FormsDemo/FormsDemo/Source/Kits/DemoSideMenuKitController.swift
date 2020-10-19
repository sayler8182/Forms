//
//  DemoSideMenuKitController.swift
//  FormsDemo
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsSideMenuKit
import FormsUtils
import UIKit

// MARK: DemoSideMenuKitController
class DemoSideMenuKitController: SideMenuController {
    private let _leftSide = DemoMenuViewController()
    private let _rightSide = DemoMenuViewController()
    private let _content = DemoContentViewController()
    
    override func setupConfiguration() {
        super.setupConfiguration()
        self.rightSideWidth = 200
    }
    
    override func setupContent() {
        super.setupContent()
        self.setLeftSide(self._leftSide.embeded)
        self.setRightSide(self._rightSide.embeded)
        self.setContent(self._content.embeded)
    }
}

// MARK: DemoMenuViewController
private class DemoMenuViewController: FormsTableViewController {
    private let closeButton = Components.button.default()
        .with(title: "Close")
    
    private let divider = Components.utils.divider()
        .with(height: 5)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.closeButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.closeButton.onClick = Unowned(self) { (_self) in
            _self.sideMenuController?.close()
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
        self.openLeftButton.onClick = Unowned(self) { (_self) in
            _self.sideMenuController?.open(direction: .left)
        }
        self.openRightButton.onClick = Unowned(self) { (_self) in
            _self.sideMenuController?.open(direction: .right)
        }
    }
}
