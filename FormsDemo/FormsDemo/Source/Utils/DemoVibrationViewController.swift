//
//  DemoVibrationViewController.swift
//  FormsDemo
//
//  Created by Konrad on 9/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsUtils
import UIKit

// MARK: DemoVibrationViewController
class DemoVibrationViewController: FormsTableViewController {
    private let warningButton = Components.button.default()
        .with(title: "Warning")
    private let heavyButton = Components.button.default()
        .with(title: "Heavy")
    private let rigidButton = Components.button.default()
        .with(title: "Rigid")
    private let selectionButton = Components.button.default()
        .with(title: "Selection")
    
    private let divider = Components.utils.divider()
        .with(height: 5)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.warningButton,
            self.heavyButton,
            self.rigidButton,
            self.selectionButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.warningButton.onClick = Unowned(self) { (_self) in
            _self.vibration(with: .warning)
        }
        self.heavyButton.onClick = Unowned(self) { (_self) in
            _self.vibration(with: .heavy)
        }
        self.rigidButton.onClick = Unowned(self) { (_self) in
            _self.vibration(with: .rigid)
        }
        self.selectionButton.onClick = Unowned(self) { (_self) in
            _self.vibration(with: .selection)
        }
    }
    
    private func vibration(with vibration: Vibration) {
        vibration.vibrate()
    }
}
