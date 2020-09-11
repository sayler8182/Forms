//
//  DemoDatesViewController.swift
//  FormsDemo
//
//  Created by Konrad on 8/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoDatesViewController
class DemoDatesViewController: FormsTableViewController {
    private let datePicker = Components.dates.date.default()
        .with(marginHorizontal: 16)
    private let timePicker = Components.dates.time.default()
        .with(marginHorizontal: 16)
    private let dateAndTimePicker = Components.dates.dateAndTime.default()
        .with(marginHorizontal: 16)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.datePicker,
            self.timePicker,
            self.dateAndTimePicker
        ], divider: self.divider)
    }
}
