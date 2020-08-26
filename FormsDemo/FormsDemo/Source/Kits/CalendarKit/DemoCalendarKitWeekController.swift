//
//  DemoCalendarKitWeekController.swift
//  FormsDemo
//
//  Created by Konrad on 8/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsCalendarKit
import FormsToastKit
import UIKit

// MARK: DemoCalendarKitWeekController
class DemoCalendarKitWeekController: FormsTableViewController {
    private let week = Components.calendar.week()
    private let styledWeek = Components.calendar.week()
        .with(settings: CalendarSettings()
            .with(weekdayBegin: .sunday)
            .with(weekdayFormat: "EEEE"))

    private let divider = Components.utils.divider()
        .with(height: 5.0)

    override func setupContent() {
        super.setupContent()
        self.build([
            self.week,
            self.styledWeek
        ], divider: self.divider)
    }
}
