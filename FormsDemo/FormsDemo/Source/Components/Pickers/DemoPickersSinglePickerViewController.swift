//
//  DemoPickersSinglePickerViewController.swift
//  FormsDemo
//
//  Created by Konrad on 10/20/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoSinglePickerItem
private enum DemoSinglePickerItem: Int, SinglePickerItem, CaseIterable {
    case option1 = 0
    case option2 = 1
    case option3 = 2
    case option4 = 3
    
    var title: String {
        switch self {
        case .option1: return "Option 1"
        case .option2: return "Option 2"
        case .option3: return "Option 3"
        case .option4: return "Option 4"
        }
    }
}

// MARK: DemoPickersSinglePickerViewController
class DemoPickersSinglePickerViewController: FormsTableViewController {
    private let singlePicker = Components.pickers.single()
        .with(items: DemoSinglePickerItem.allCases)
        .with(marginHorizontal: 16)
        .with(selected: DemoSinglePickerItem.option4)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.singlePicker
        ], divider: self.divider)
    }
}
