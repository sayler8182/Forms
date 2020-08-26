//
//  Date.swift
//  FormsUtils
//
//  Created by Konrad on 5/19/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import Foundation

private let kDateFormatter: DateFormatter = DateFormatter()

// MARK: DateFormatProtocol
public protocol DateFormatProtocol {
    var dateFormat: String { get }
    var timeFormat: String { get }
    var fullFormat: String { get }
}

public struct DateFormat: DateFormatProtocol {
    public var dateFormat: String
    public var timeFormat: String
    public var fullFormat: String
    
    public init(dateFormat: String,
                timeFormat: String,
                fullFormat: String) {
        self.dateFormat = dateFormat
        self.timeFormat = timeFormat
        self.fullFormat = fullFormat
    }
}

// MARK: DateFormatType
public enum DateFormatType: CaseIterable {
    case date
    case time
    case full
    
    var format: String {
        let dateFormat: DateFormatProtocol? = Injector.main.resolveOrDefault("FormsUtils")
        switch self {
        case .date: return dateFormat?.dateFormat ?? "yyyy-MM-dd"
        case .time: return dateFormat?.timeFormat ?? "HH:mm"
        case .full: return dateFormat?.fullFormat ?? "yyyy-MM-dd HH:mm"
        }
    }
}

// MARK: FromDateFormattable
public protocol FromDateFormattable {
    var asDate: Date? { get }
}

public extension FromDateFormattable {
    var isDate: Bool {
        return self.asDate.isNotNil
    }
    
    func formatted(prefix: String? = nil,
                   suffix: String? = nil,
                   format formatType: DateFormatType) -> String? {
        return self.formatted(
            prefix: prefix,
            suffix: suffix,
            format: formatType.format)
    }
    
    func formatted(prefix: String? = nil,
                   suffix: String? = nil,
                   format: String) -> String? {
        guard let date: Date = self.asDate else { return nil }
        kDateFormatter.dateFormat = format
        var string: String = kDateFormatter.string(from: date)
        if let prefix: String = prefix {
            string.insert(contentsOf: prefix, at: string.startIndex)
        }
        if let suffix: String = suffix {
            string.append(suffix)
        }
        return string
    }
}

// MARK: ToDateFormattable
public protocol ToDateFormattable {
    var asString: String { get }
}

public extension ToDateFormattable {
    func asDate(format formatType: DateFormatType) -> Date? {
        return self.asDate(format: formatType.format)
    }
    
    func asDate(format: String) -> Date? {
        kDateFormatter.dateFormat = format
        return kDateFormatter.date(from: self.asString)
    }
}

// MARK: Date
extension Date: FromDateFormattable {
    public var asDate: Date? {
        return self
    }
}

// MARK: String
extension String: FromDateFormattable, ToDateFormattable {
    public var asDate: Date? {
        for format in DateFormatType.allCases {
            guard let date: Date = self.asDate(format: format) else { continue }
            return date
        }
        return nil
    }
}

// MARK: Int
extension Int: FromDateFormattable, ToDateFormattable {
    public var asDate: Date? {
        return Date(timeIntervalSince1970: Double(self))
    }
}

// MARK: Double
extension Double: FromDateFormattable, ToDateFormattable {
    public var asDate: Date? {
        return Date(timeIntervalSince1970: self)
    }
}

// MARK: Date
public extension Date {
    static var unixStartDate: Date {
        return Date(timeIntervalSince1970: 0)
    }
    
    static func date(in range: Range<Date>,
                     every: Int = 1,
                     interval: Calendar.Component = .day) -> [Date] {
        return Self.date(
            from: range.lowerBound,
            to: range.upperBound.adding(interval, value: -1),
            every: every,
            interval: interval)
    }
    
    static func date(in range: ClosedRange<Date>,
                     every: Int = 1,
                     interval: Calendar.Component = .day) -> [Date] {
        return Self.date(
            from: range.lowerBound,
            to: range.upperBound,
            every: every,
        interval: interval)
    }
    
    static func date(from: Date,
                     to: Date,
                     every value: Int = 1,
                     interval component: Calendar.Component = .day) -> [Date] {
        var dates: [Date] = []
        var date: Date = from
        while date <= to {
            dates.append(date)
            date = date.adding(component, value: value)
        }
        return dates
    }
    
    init(_ components: [Calendar.Component: Int]) {
        var dateComponents = DateComponents()
        dateComponents.year = components[.year] ?? Date.unixStartDate.year
        dateComponents.month = components[.month] ?? Date.unixStartDate.month.rawValue
        dateComponents.day = components[.day] ?? Date.unixStartDate.day
        dateComponents.hour = components[.hour] ?? Date.unixStartDate.hour
        dateComponents.minute = components[.minute] ?? Date.unixStartDate.minute
        dateComponents.second = components[.second] ?? Date.unixStartDate.second
        dateComponents.nanosecond = components[.nanosecond] ?? Date.unixStartDate.nanosecond
        let timeInterval = Calendar.current.date(from: dateComponents)?.timeIntervalSince1970 ?? 0
        self.init(timeIntervalSince1970: timeInterval)
    }
    
    var calendar: Calendar {
        return Calendar.current
    }
    
    var quarter: Int {
        let month: Double = self.calendar.component(.month, from: self).asDouble
        return (month / 12.0).ceiled.asInt
    }
    
    var weekday: Weekday! {
        var weekday: Int = self.calendar.component(.weekday, from: self)
        weekday = weekday == 1 ? 7 : weekday - 1
        return Weekday(weekday)
    }
    
    var weekOfYear: Int {
        return self.calendar.component(.weekOfYear, from: self)
    }
    
    var weekOfMonth: Int {
        return self.calendar.component(.weekOfMonth, from: self)
    }
    
    var yesterday: Date! {
        return self.calendar.date(byAdding: .day, value: -1, to: self)
    }

    var tomorrow: Date! {
        return self.calendar.date(byAdding: .day, value: 1, to: self)
    }
    
    var year: Int {
        get { return self.calendar.component(.year, from: self) }
        set {
            guard newValue.inRange(0..<2_999) else { return }
            self = self.calendar.date(bySetting: .year, value: newValue, of: self) ?? self
        }
    }
    
    var month: Month {
        get {
            let month: Int = self.calendar.component(.month, from: self)
            return Month(month)
        }
        set {
            guard self.calendar.range(of: .month, in: .year, for: self)?.contains(newValue.order) == true else { return }
            self = self.calendar.date(bySetting: .month, value: newValue.order, of: self) ?? self
        }
    }
    
    var day: Int {
        get { return self.calendar.component(.day, from: self) }
        set {
            guard self.calendar.range(of: .day, in: .month, for: self)?.contains(newValue) == true else { return }
            self = self.calendar.date(bySetting: .day, value: newValue, of: self) ?? self
        }
    }
    
    var hour: Int {
        get { return self.calendar.component(.hour, from: self) }
        set {
            guard self.calendar.range(of: .hour, in: .day, for: self)?.contains(newValue) == true else { return }
            self = self.calendar.date(bySetting: .hour, value: newValue, of: self) ?? self
        }
    }
    
    var minute: Int {
        get { return self.calendar.component(.minute, from: self) }
        set {
            guard self.calendar.range(of: .minute, in: .hour, for: self)?.contains(newValue) == true else { return }
            self = self.calendar.date(bySetting: .minute, value: newValue, of: self) ?? self
        }
    }
    
    var second: Int {
        get { return self.calendar.component(.second, from: self) }
        set {
            guard self.calendar.range(of: .second, in: .minute, for: self)?.contains(newValue) == true else { return }
            self = self.calendar.date(bySetting: .second, value: newValue, of: self) ?? self
        }
    }
    
    var nanosecond: Int {
        get { return self.calendar.component(.nanosecond, from: self) }
        set {
            guard self.calendar.range(of: .nanosecond, in: .second, for: self)?.contains(newValue) == true else { return }
            self = self.calendar.date(bySetting: .nanosecond, value: newValue, of: self) ?? self
        }
    }
    
    var isFuture: Bool {
        return self > Date()
    }
        
    var isPast: Bool {
        return self < Date()
    }

    var isToday: Bool {
        return self.calendar.isDateInToday(self)
    }
    
    var isYesterday: Bool {
        return self.calendar.isDateInYesterday(self)
    }

    var isTomorrow: Bool {
        return self.calendar.isDateInTomorrow(self)
    }

    var isWeekend: Bool {
        return self.calendar.isDateInWeekend(self)
    }

    var isWorkday: Bool {
        return !self.calendar.isDateInWeekend(self)
    }

    var isCurrentWeek: Bool {
        return self.calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    var isCurrentMonth: Bool {
        return self.calendar.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    var isCurrentYear: Bool {
        return self.calendar.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    func components(to component: Calendar.Component) -> Set<Calendar.Component> {
        switch component {
        case .nanosecond: return [.year, .month, .day, .hour, .minute, .nanosecond]
        case .second: return [.year, .month, .day, .hour, .minute, .second]
        case .minute: return [.year, .month, .day, .hour, .minute]
        case .hour: return [.year, .month, .day, .hour]
        case .day: return [.year, .month, .day]
        case .month: return [.year, .month]
        case .year: return [.year]
        default: return []
        }
    }
    
    func begin(of component: Calendar.Component) -> Date! {
        let components: Set<Calendar.Component> = self.components(to: component)
        guard !components.isEmpty else { return self }
        return self.calendar.date(from: self.calendar.dateComponents(components, from: self))
    }
    
    func compare(_ date: Date?,
                 to component: Calendar.Component) -> ComparisonResult? {
        guard let date: Date = date else { return nil }
        let from: DateComponents = self.calendar.dateComponents(self.components(to: component), from: self)
        let to: DateComponents = date.calendar.dateComponents(date.components(to: component), from: date)
        guard let fromDate: Date = self.calendar.date(from: from) else { return nil }
        guard let toDate: Date = date.calendar.date(from: to) else { return nil }
        return fromDate.compare(toDate)
    }

    func end(of component: Calendar.Component) -> Date! {
        let components: Set<Calendar.Component> = self.components(to: component)
        guard !components.isEmpty else { return self }
        var date: Date! = self.adding(component, value: 1)
        date = self.calendar.date(from: self.calendar.dateComponents(components, from: date))
        return date
    }
    
    func isCurrent(_ component: Calendar.Component) -> Bool {
        return self.calendar.isDate(self, equalTo: Date(), toGranularity: component)
      }
    
    func inRange(_ range: Range<Self>) -> Bool {
        return range.lowerBound <= self && self < range.upperBound
    }
    
    func inRange(_ range: ClosedRange<Self>) -> Bool {
        return range.lowerBound <= self && self <= range.upperBound
    }
    
    var nearestHour: Date! {
        let minutes = self.calendar.component(.minute, from: self)
        let components: DateComponents = self.calendar.dateComponents(self.components(to: .hour), from: self)
        let date: Date! = self.calendar.date(from: components)
        return minutes < 30
            ? date
            : self.calendar.date(byAdding: .hour, value: 1, to: date)
    }
    
    var daysInMonth: Int! {
        return self.calendar.range(of: .day, in: .month, for: self)?.count
    }
    
    func adding(_ component: Calendar.Component, value: Int) -> Date! {
        return self.calendar.date(byAdding: component, value: value, to: self)
    }
    
    mutating func add(_ component: Calendar.Component,
                      value: Int) {
        self = calendar.date(byAdding: component, value: value, to: self) ?? self
    }
    
    func nearest(accuracyInMin accuracy: Int) -> Date! {
        var components: DateComponents = self.calendar.dateComponents(self.components(to: .minute), from: self)
        let minutes: Int = self.calendar.component(.minute, from: self)
        components.minute = minutes % accuracy < (accuracy.asDouble / 2.0).ceiled.asInt
            ? minutes - minutes % accuracy
            : minutes + accuracy - (minutes % accuracy)
        return calendar.date(from: components)
    }
    
    mutating func with(_ component: Calendar.Component, value: Int) -> Date! {
        var date: Date! = self
        switch component {
        case .second: date.second = value
        case .minute: date.minute = value
        case .hour: date.hour = value
        case .day: date.day = value
        case .month: date.month = Month(value)
        case .year: date.year = value
        default: date = self.calendar.date(bySetting: component, value: value, of: date)
        }
        return date
    }
}

// MARK: Weekday
public enum Weekday: Int, CaseIterable, Equatable, Comparable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    public var order: Int {
        return self.rawValue + 1
    }
    
    public init?(_ order: Int) {
        self.init(rawValue: order - 1)
    }
    
    public func title(for format: String) -> String {
        let date: Date = Date.unixStartDate
            .adding(.day, value: self.rawValue - 3)
        kDateFormatter.dateFormat = format
        return kDateFormatter.string(from: date)
    }
    
    public static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

// MARK: Month
public enum Month: Int, CaseIterable, Equatable, Comparable {
    case january
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
    
    public var order: Int {
        return self.rawValue + 1
    }
    
    public init!(_ order: Int) {
        self.init(rawValue: order - 1)
    }
    
    public func title(for format: String) -> String {
        let date: Date = Date.unixStartDate
            .adding(.month, value: self.rawValue)
        kDateFormatter.dateFormat = format
        return kDateFormatter.string(from: date)
    }
    
    public static func < (lhs: Month, rhs: Month) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
