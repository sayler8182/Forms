//
//  CalendarSettings.swift
//  FormsCalendarKit
//
//  Created by Konrad on 8/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import Foundation

// MARK: CalendarSettings
public class CalendarSettings {
    public var weekdayBegin: Weekday = .monday
    public var weekdayFormat: String = "EE"
    
    public init() { }
}

// MARK: Builder
public extension CalendarSettings {
    func with(weekdayBegin: Weekday) -> Self {
        self.weekdayBegin = weekdayBegin
        return self
    }
    func with(weekdayFormat: String) -> Self {
        self.weekdayFormat = weekdayFormat
        return self
    }
}
