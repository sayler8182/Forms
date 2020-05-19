//
//  Date.swift
//  Utils
//
//  Created by Konrad on 5/19/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Injector
import UIKit

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
        let dateFormat: DateFormatProtocol? = Injector.main.resolve()
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

// MARK: CGFloat
extension CGFloat: FromDateFormattable, ToDateFormattable {
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
