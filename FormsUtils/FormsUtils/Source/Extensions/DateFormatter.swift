//
//  DateFormatter.swift
//  FormsUtils
//
//  Created by Konrad on 8/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: DateFormatter
public extension DateFormatter { }

// MARK: Builder
public extension DateFormatter {
    func with(calendar: Calendar?) -> Self {
        self.calendar = calendar
        return self
    }
    func with(locale: Locale?) -> Self {
        self.locale = locale
        return self
    }
    func with(timeZone: TimeZone?) -> Self {
        self.timeZone = timeZone
        return self
    }
}
