//
//  DemoDebouncerViewController.swift
//  FormsDemo
//
//  Created by Konrad on 6/18/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsUtils
import UIKit

// MARK: DemoDebouncerViewController
class DemoDebouncerViewController: FormsTableViewController {
    private let inputTextField = Components.input.textField.default()
        .with(title: "Debouncer input")
    private let outputLabel = Components.label.default()
        .with(paddingVertical: 4, paddingHorizontal: 16)
        .with(text: "Wait for debounce")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    private let debouncer = Debouncer(interval: 0.5)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.inputTextField,
            self.outputLabel
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.inputTextField.onTextChanged = Unowned(self) { (_self: DemoDebouncerViewController, text) in
            _self.debouncer.debounce { [weak _self] in
                guard let _self = _self else { return }
                _self.outputLabel.text = text
            }
        }
    }
}
