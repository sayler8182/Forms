//
//  DemoSelectorsViewController.swift
//  FormsDemo
//
//  Created by Konrad on 8/21/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsUtils
import UIKit
 
// MARK: DemoSelectorItem
private enum DemoSelectorItem: Int, SelectorItem, CaseIterable {
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

// MARK: DemoSelectorsViewController
class DemoSelectorsViewController: FormsTableViewController {
    private let horizontalSegment = Components.selector.default()
        .with(items: DemoSelectorItem.allCases)
    private let verticalSegment = Components.selector.default()
        .with(direction: .vertical)
        .with(selected: DemoSelectorItem.option3)
        .with(items: DemoSelectorItem.allCases)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.horizontalSegment,
            self.verticalSegment
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.horizontalSegment.onValuePrev = Unowned(self) { (_, item) in
            print("Value prev:", item.title)
        }
        self.horizontalSegment.onValueChanged = Unowned(self) { (_, item) in
            print("Value change:", item.title)
        }
        self.horizontalSegment.onValueNext = Unowned(self) { (_, item) in
            print("Value next:", item.title)
        }
    }
}
