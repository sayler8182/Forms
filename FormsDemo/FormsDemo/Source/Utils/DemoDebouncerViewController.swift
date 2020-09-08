//
//  DemoDebouncerViewController.swift
//  FormsDemo
//
//  Created by Konrad on 6/18/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsUtils
import UIKit

// MARK: DemoDebouncerViewController
class DemoDebouncerViewController: FormsTableViewController {
    private let inputTextField = Components.input.textField.default()
        .with(title: "Debouncer input")
    private let outputLabel = Components.label.default()
        .with(marginVertical: 4, marginHorizontal: 16)
        .with(text: "Waiting for debounce")
    private let invalidateButton = Components.button.default()
        .with(title: "Invalidate")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    private let debouncer = Debouncer(interval: 1)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.inputTextField,
            self.outputLabel,
            self.invalidateButton
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
        self.invalidateButton.onClick = Unowned(self) { (_self) in
            _self.debouncer.invalidate()
        }
    }
}
