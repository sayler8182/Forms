//
//  DemoPinViewViewController.swift
//  FormsDemo
//
//  Created by Konrad on 5/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit
import Utils
import Validators

// MARK: DemoPinViewViewController
class DemoPinViewViewController: FormsTableViewController {
    private let pinView = Components.input.pin.default()
        .with(error: "Some error")
        .with(info: LoremIpsum.sentence)
        .with(keyboardType: .default)
        .with(placeholder: "Text")
        .with(title: "Pin")
    private let pinLongView = Components.input.pin.default()
        .with(info: LoremIpsum.sentence)
        .with(numberOfChars: 8)
        .with(placeholder: "Text")
        .with(title: "Pin")
        .with(validator: LengthValidator(length: 8))
        .with(validateOnEndEditing: true)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.pinView,
            self.pinLongView
        ], divider: self.divider)
    }
}
