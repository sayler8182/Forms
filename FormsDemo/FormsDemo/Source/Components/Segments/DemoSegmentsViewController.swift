//
//  DemoSegmentsViewController.swift
//  FormsDemo
//
//  Created by Konrad on 6/10/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoSegmentItem
private enum DemoSegmentItem: Int, SegmentItem, CaseIterable {
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

// MARK: DemoSegmentsViewController
class DemoSegmentsViewController: FormsTableViewController {
    private let defaultSegment = Components.segment.default()
        .with(items: DemoSegmentItem.allCases)
     private let selectedSegment = Components.segment.default()
        .with(disabled: [DemoSegmentItem.option3])
        .with(items: DemoSegmentItem.allCases)
        .with(selected: DemoSegmentItem.option1)
    private let disabledSegment = Components.segment.default()
        .with(items: DemoSegmentItem.allCases)
        .with(isEnabled: false)
    private let disabledSelectedSegment = Components.segment.default()
        .with(items: DemoSegmentItem.allCases)
        .with(isEnabled: false)
        .with(selected: DemoSegmentItem.option3)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.defaultSegment,
            self.selectedSegment,
            self.disabledSegment,
            self.disabledSelectedSegment
        ], divider: self.divider)
    }
}
