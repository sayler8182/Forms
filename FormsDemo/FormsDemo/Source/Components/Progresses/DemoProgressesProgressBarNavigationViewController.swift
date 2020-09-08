//
//  DemoProgressesProgressBarNavigationViewController.swift
//  FormsDemo
//
//  Created by Konrad on 5/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsUtils
import UIKit

// MARK: DemoProgressesProgressBarNavigationViewController
class DemoProgressesProgressBarNavigationViewController: FormsNavigationController {
    private let navigationProgressBar = Components.progress.default()
        .with(progress: 1.0 / 3.0)
    
    override func postInit() {
        super.postInit()
        self.setRoot(DemoFirstViewController())
    }
    
    override func setTheme() {
        self.navigationProgressBar.setupView()
        super.setTheme()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.setNavigationProgressBar(self.navigationProgressBar)
    }
}

// MARK: DemoFirstViewController
private class DemoFirstViewController: FormsTableViewController {
    private let navigationBar = Components.navigationBar.default()
        .with(title: "First")
        .with(progress: 1.0 / 3.0)
    private let nextButton = Components.button.default()
        .with(title: "Next")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.divider,
            self.nextButton
        ], divider: self.divider)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.setNavigationBar(self.navigationBar)
    }
    
    override func setupActions() {
        super.setupActions()
        self.nextButton.onClick = Unowned(self) { (_self) in
            let controller = DemoSecondViewController()
            _self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: DemoSecondViewController
private class DemoSecondViewController: FormsTableViewController {
    private let navigationBar = Components.navigationBar.default()
        .with(title: "Second")
        .with(progress: 2.0 / 3.0)
    private let backButton = Components.button.default()
        .with(title: "Back")
    private let nextButton = Components.button.default()
        .with(title: "Next")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.divider,
            self.backButton,
            self.nextButton
        ], divider: self.divider)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.setNavigationBar(self.navigationBar)
    }
    
    override func setupActions() {
        super.setupActions()
        self.backButton.onClick = Unowned(self) { (_self) in
            _self.navigationController?.popViewController(animated: true)
        }
        self.nextButton.onClick = Unowned(self) { (_self) in
            let controller = DemoThirdViewController()
            _self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: DemoThirdViewController
private class DemoThirdViewController: FormsTableViewController {
    private let navigationBar = Components.navigationBar.default()
        .with(title: "Third")
        .with(progress: 3.0 / 3.0)
    private let backButton = Components.button.default()
        .with(title: "Back")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.divider,
            self.backButton
        ], divider: self.divider)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.setNavigationBar(self.navigationBar)
    }
    
    override func setupActions() {
        super.setupActions()
        self.backButton.onClick = Unowned(self) { (_self) in
            _self.navigationController?.popViewController(animated: true)
        }
    }
}
