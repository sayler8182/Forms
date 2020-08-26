//
//  Date.swift
//  FormsCalendarKit
//
//  Created by Konrad on 8/24/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: Date
internal extension Date {
    var rowsCount: Int {
        let days: Int = self.weekday.rawValue + self.daysInMonth
        return (days.asDouble / 7).ceiled.asInt
    }
}
