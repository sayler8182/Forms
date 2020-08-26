//
//  DemoCalendarKitMonthWithWeekController.swift
//  FormsDemo
//
//  Created by Konrad on 8/24/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsCalendarKit
import FormsToastKit
import UIKit

// MARK: DemoCalendarKitMonthWithWeekController
class DemoCalendarKitMonthWithWeekController: FormsTableViewController {
    private let monthWithWeek = Components.calendar.monthWithWeek()
        .with(date: Date())
        .with(month: .january)
    
    private let divider = Components.utils.divider()
        .with(height: 50.0)

    override func setupContent() {
        super.setupContent()
        self.build([
            self.monthWithWeek
        ], divider: self.divider)
    }
}
