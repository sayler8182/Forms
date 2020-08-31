//
//  DemoInputViewViewController.swift
//  FormsDemo
//
//  Created by Konrad on 8/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsUtils
import FormsUtilsUI
import UIKit

// MARK: DemoInputViewViewController
class DemoInputViewViewController: FormsTableViewController {
    private let inputTextField = Components.input.textField.default()
        .with(title: "Input")
    private let toolbarButton = Components.button.default()
        .with(title: "Set toolbar")
    private let inputButton = Components.button.default()
    .with(title: "Set input")
    private let resetButton = Components.button.default()
        .with(title: "Reset")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.inputTextField,
            self.toolbarButton,
            self.inputButton,
            self.resetButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.toolbarButton.onClick = Unowned(self) { (_self) in
            _self.inputTextField.setInputView(
                accessory: ToolbarAccessoryView([
                    BarButtonItem(title: "Cancel"),
                    BarButtonItem.flexible,
                    BarButtonItem(title: "Done")
                        .with(lostFocusOnClick: false)
                ]))
            _self.inputTextField.reloadInputViews()
            _self.updateInputTitle()
        }
        self.inputButton.onClick = Unowned(self) { (_self) in
            _self.inputTextField.setInputView(
                input: InputView(
                    Components.dates.date.default()
                ))
            _self.inputTextField.reloadInputViews()
            _self.updateInputTitle()
        }
        self.resetButton.onClick = Unowned(self) { (_self) in
            _self.inputTextField.removeInputView()
            _self.inputTextField.reloadInputViews()
            _self.updateInputTitle()
        }
    }
    
    private func updateInputTitle() {
        self.inputTextField.title = [
            "Input",
            [
                self.inputTextField.inputableView.isNotNil ? "InputView" : nil,
                self.inputTextField.inputableAccessoryView.isNotNil ? "InputAccessoryView" : nil
                ]
                .joined(separator: " and ", skipEmpty: true)
            ].joined(separator: " with ", skipEmpty: true)
    }
}
