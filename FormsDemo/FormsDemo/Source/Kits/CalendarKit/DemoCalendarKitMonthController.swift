//
//  DemoCalendarKitMonthController.swift
//  FormsDemo
//
//  Created by Konrad on 8/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsCalendarKit
import FormsToastKit
import UIKit

// MARK: DemoCalendarKitMonthController
class DemoCalendarKitMonthController: FormsTableViewController {
    private let month = Components.calendar.month()
        .with(date: Date())
        .with(month: .january)
    private let styledMonth = Components.calendar.month()
        .with(date: Date())
        .with(selectionType: .multiple)
        .with(settings: CalendarSettings()
            .with(weekdayBegin: .sunday))
    private let rangeMonth = Components.calendar.month()
        .with(selectionType: .range)
    
    private let divider = Components.utils.divider()
        .with(height: 50.0)

    override func setupContent() {
        super.setupContent()
        self.build([
            self.month,
            self.styledMonth,
            self.rangeMonth
        ], divider: self.divider)
    } 
}
