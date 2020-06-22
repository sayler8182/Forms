//
//  DemoSwitchesViewController.swift
//  FormsDemo
//
//  Created by Konrad on 6/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsUtils
import UIKit

// MARK: DemoSwitchesViewController
class DemoSwitchesViewController: FormsTableViewController {
    private let switch_1_1 = Components.switch.default()
        .with(groupKey: "switch_1")
        .with(isSelected: true)
        .with(marginVertical: 4, marginHorizontal: 8)
        .with(title: "Some title")
        .with(value: "Some value")
    private let switch_1_2 = Components.switch.default()
        .with(groupKey: "switch_1")
        .with(marginVertical: 4, marginHorizontal: 8)
        .with(title: "Some title")
    private let switch_2_1 = Components.switch.default()
        .with(marginVertical: 4, marginHorizontal: 8)
        .with(value: "Some value")
    private let switch_2_2 = Components.switch.default()
        .with(isEnabled: false)
        .with(isSelected: true)
        .with(marginVertical: 4, marginHorizontal: 8)
        .with(title: LoremIpsum.sentence)
        .with(value: LoremIpsum.paragraph(sentences: 3))
     
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.switch_1_1,
            self.switch_1_2,
            self.switch_2_1,
            self.switch_2_2
        ], divider: self.divider)
    }
}
