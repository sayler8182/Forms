//
//  DemoThemeViewController.swift
//  FormsDemo
//
//  Created by Konrad on 5/13/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoThemeViewController
class DemoThemeViewController: FormsTableViewController {
    private let lightThemeButton = Components.button.default()
        .with(title: "Light Theme")
    private let darkThemeButton = Components.button.default()
        .with(title: "Dark Theme")
    private let defaultThemeButton = Components.button.default()
        .with(title: "Defaullt Theme")
    
    private let divider = Components.utils.divider()
        .with(height: 5)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.lightThemeButton,
            self.darkThemeButton,
            self.defaultThemeButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.lightThemeButton.onClick = {
            Theme.setTheme(.light)
        }
        self.darkThemeButton.onClick = {
            Theme.setTheme(.dark)
        }
        self.defaultThemeButton.onClick = {
            Theme.setTheme(nil)
        }
    }
}
