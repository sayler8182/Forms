//
//  DemoCheckboxesViewController.swift
//  FormsDemo
//
//  Created by Konrad on 6/3/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsUtils
import UIKit

// MARK: DemoCheckboxesViewController
class DemoCheckboxesViewController: FormsTableViewController {
    private let checkboxLabel = Components.label.default()
        .with(padding: 8)
        .with(text: "Checkbox")
    private let checkbox_1_1 = Components.checkbox.checkbox()
        .with(isSelected: true)
        .with(paddingVertical: 4, paddingHorizontal: 8)
        .with(title: "Some title")
        .with(value: "Some value")
    private let checkbox_1_2 = Components.checkbox.checkbox()
        .with(paddingVertical: 4, paddingHorizontal: 8)
        .with(title: "Some title")
    private let checkbox_1_3 = Components.checkbox.checkbox()
        .with(paddingVertical: 4, paddingHorizontal: 8)
        .with(value: "Some value")
    private let checkbox_1_4 = Components.checkbox.checkbox()
        .with(isEnabled: false)
        .with(isSelected: true)
        .with(paddingVertical: 4, paddingHorizontal: 8)
        .with(title: LoremIpsum.sentence)
        .with(value: LoremIpsum.paragraph(sentences: 3))
    private let radioLabel = Components.label.default()
        .with(paddingVertical: 4, paddingHorizontal: 8)
        .with(text: "Radio")
    private let radio_1_1 = Components.checkbox.radio()
        .with(isSelected: true)
        .with(paddingVertical: 4, paddingHorizontal: 8)
        .with(title: "Some title")
        .with(value: "Some value")
    private let radio_1_2 = Components.checkbox.radio()
        .with(paddingVertical: 4, paddingHorizontal: 8)
        .with(title: "Some title")
    private let radio_1_3 = Components.checkbox.radio()
        .with(paddingVertical: 4, paddingHorizontal: 8)
        .with(value: "Some value")
    private let radio_1_4 = Components.checkbox.radio()
        .with(isEnabled: false)
        .with(paddingVertical: 4, paddingHorizontal: 8)
        .with(title: LoremIpsum.sentence)
        .with(value: LoremIpsum.paragraph(sentences: 3))
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.checkboxLabel,
            self.checkbox_1_1,
            self.checkbox_1_2,
            self.checkbox_1_3,
            self.checkbox_1_4,
            self.radioLabel,
            self.radio_1_1,
            self.radio_1_2,
            self.radio_1_3,
            self.radio_1_4
        ], divider: self.divider)
    }
}
