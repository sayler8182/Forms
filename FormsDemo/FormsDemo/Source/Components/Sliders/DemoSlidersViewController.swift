//
//  DemoSlidersViewController.swift
//  FormsDemo
//
//  Created by Konrad on 10/22/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsUtils
import UIKit

// MARK: DemoSlidersViewController
class DemoSlidersViewController: FormsTableViewController {
    private let slider = Components.sliders.default()
        .with(minValue: 0)
        .with(maxValue: 1)
        .with(value: 0.75)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.slider
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.slider.onValueChanged = Unowned(self) { (_, value) in
            print("Value:", value)
        }
    }
}
