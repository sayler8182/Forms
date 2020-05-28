//
//  Number.swift
//  FormsUtils
//
//  Created by Konrad on 3/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import UIKit

private let kNumberFormatter: NumberFormatter = NumberFormatter()

// MARK: NumberFormatProtocol
public protocol NumberFormatProtocol {
    var fractionDigits: Int { get }
    var groupingSeparator: String { get }
    var decimalSeparator: String { get }
}

public struct NumberFormat: NumberFormatProtocol {
    public var fractionDigits: Int
    public var groupingSeparator: String
    public var decimalSeparator: String
    
    public init(fractionDigits: Int,
                groupingSeparator: String,
                decimalSeparator: String) {
        self.fractionDigits = fractionDigits
        self.groupingSeparator = groupingSeparator
        self.decimalSeparator = decimalSeparator
    }
}

// MARK: Constant
public extension CGFloat {
    static var greatestConstraintConstant: CGFloat {
        return 100_000
    }
}

// MARK: String
public extension String {
    var isNumber: Bool {
        return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

public extension String {
    var asBool: Bool? { self.asDouble?.asBool }
    var asCGFloat: CGFloat? { self.asDouble?.asCGFloat }
    var asDecimal: Decimal? { self.asDouble?.asDecimal }
    var asDouble: Double? {
        let string: String = self
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: ".")
        return Double(string)
    }
    var asInt: Int? { self.asDouble?.asInt }
    var asNumber: NSNumber? { self.asDouble?.asNumber }
    var asString: String { self }
    var isFractional: Bool { self.contains(".") }
}

public extension Optional where Wrapped == String {
    var asBool: Bool? { self?.asBool }
    var asCGFloat: CGFloat? { self?.asCGFloat }
    var asDecimal: Decimal? { self?.asDecimal }
    var asDouble: Double? { self?.asDouble }
    var asInt: Int? { self?.asInt }
    var asNumber: NSNumber? { self?.asNumber }
    var asString: String? { self?.asString }
    var isFractional: Bool? { self?.isFractional }
}

// MARK: Number
public protocol Number: Comparable {
    var asBool: Bool { get }
    var asCGFloat: CGFloat { get }
    var asDecimal: Decimal { get }
    var asDouble: Double { get }
    var asInt: Int { get }
    var asNumber: NSNumber { get }
    var asString: String { get }
    var isFractional: Bool { get }
    
    var ceiled: Self { get }
    var floored: Self { get }
    
    func inRange(_ range: Range<Self>) -> Bool
    func match(in range: Range<Self>) -> Self
    func match(from: Self, to: Self) -> Self
    func reversed(progress: Self) -> Self
}

public extension Number {
    var isNegative: Bool {
        return self.asDouble < 0.0
    }
    
    var isPositive: Bool {
        return self.asDouble > 0.0
    }
    
    var isZero: Bool {
        return self.asDouble == 0.0
    }
    
    func greaterThan(_ value: Self) -> Bool {
        return self > value
    }
    
    func greaterThanOrEqual(_ value: Self) -> Bool {
        return self >= value
    }
    
    func equal(_ value: Self) -> Bool {
        return self == value
    }
    
    func lessThan(_ value: Self) -> Bool {
        return self < value
    }
    
    func lessThanOrEqual(_ value: Self) -> Bool {
        return self <= value
    }
}

// MARK: NumberFormattable
public protocol NumberFormattable {
    var asNumber: NSNumber { get }
    var isFractional: Bool { get }
}

public extension NumberFormattable {
    func formatted(prefix: String? = nil,
                   suffix: String? = nil,
                   fractionDigits: Int? = nil,
                   groupingSeparator: String? = nil,
                   decimalSeparator: String? = nil) -> String {
        return self.formatted(
            prefix: prefix,
            suffix: suffix,
            minFractionDigits: fractionDigits,
            maxFractionDigits: fractionDigits,
            groupingSeparator: groupingSeparator,
            decimalSeparator: decimalSeparator)
    }
    
    func formatted(prefix: String? = nil,
                   suffix: String? = nil,
                   minFractionDigits: Int? = nil,
                   maxFractionDigits: Int? = nil,
                   groupingSeparator: String? = nil,
                   decimalSeparator: String? = nil) -> String {
        let numberFormat: NumberFormatProtocol? = Injector.main.resolve()
        kNumberFormatter.groupingSeparator = groupingSeparator ?? numberFormat?.groupingSeparator ?? ","
        kNumberFormatter.decimalSeparator = decimalSeparator ?? numberFormat?.decimalSeparator ?? ","
        kNumberFormatter.numberStyle = .decimal
        kNumberFormatter.minimumFractionDigits = self.isFractional
            ? minFractionDigits ?? numberFormat?.fractionDigits ?? 2
            : minFractionDigits ?? 0
        kNumberFormatter.maximumFractionDigits = self.isFractional
            ? maxFractionDigits ?? numberFormat?.fractionDigits ?? 2
            : maxFractionDigits ?? 0
        var string: String = kNumberFormatter.string(from: self.asNumber).or("")
        if let prefix: String = prefix {
            string.insert(contentsOf: prefix, at: string.startIndex)
        }
        if let suffix: String = suffix {
            string.append(suffix)
        }
        return string
    }
}

// MARK: CGFloat
extension CGFloat: Number, NumberFormattable {
    public var asBool: Bool { self != 0.0 }
    public var asCGFloat: CGFloat { self }
    public var asDecimal: Decimal { self.asDouble.asDecimal }
    public var asDouble: Double { Double(self) }
    public var asInt: Int { Int(self) }
    public var asNumber: NSNumber { self as NSNumber }
    public var asString: String { self.asDouble.asString }
    public var isFractional: Bool { true }
    
    public var ceiled: CGFloat { self.rounded(.up) }
    public var floored: CGFloat { self.rounded(.down) }
    
    public func inRange(_ range: Range<Self>) -> Bool {
        return range.contains(self)
    }
    public func match(in range: Range<Self>) -> CGFloat {
        return Swift.min(Swift.max(range.lowerBound, self), range.upperBound)
    }
    public func match(from: Self, to: Self) -> CGFloat {
        return Swift.min(Swift.max(from, self), to)
    }
    public func reversed(progress: CGFloat) -> CGFloat {
        return progress - self
    }
}

// MARK: Double
extension Double: Number, NumberFormattable {
    public var asBool: Bool { self != 0.0 }
    public var asCGFloat: CGFloat { CGFloat(self) }
    public var asDecimal: Decimal { Decimal(self) }
    public var asDouble: Double { self }
    public var asInt: Int { Int(self) }
    public var asNumber: NSNumber { self as NSNumber }
    public var asString: String { String(self) }
    public var isFractional: Bool { true }
    
    public var ceiled: Double { self.rounded(.up) }
    public var floored: Double { self.rounded(.down) }
    
    public func inRange(_ range: Range<Self>) -> Bool {
        return range.contains(self)
    }
    public func match(in range: Range<Self>) -> Double {
        return Swift.min(Swift.max(range.lowerBound, self), range.upperBound)
    }
    public func match(from: Self, to: Self) -> Double {
        return Swift.min(Swift.max(from, self), to)
    }
    public func reversed(progress: Double) -> Double {
        return progress - self
    }
}

// MARK: Int
extension Int: Number, NumberFormattable {
    public var asBool: Bool { self != 0 }
    public var asCGFloat: CGFloat { CGFloat(self) }
    public var asDecimal: Decimal { Decimal(self) }
    public var asDouble: Double { Double(self) }
    public var asInt: Int { self }
    public var asNumber: NSNumber { self as NSNumber }
    public var asString: String { String(self) }
    public var isFractional: Bool { false }
    
    public var ceiled: Int { self }
    public var floored: Int { self }
    
    public func inRange(_ range: Range<Self>) -> Bool {
        return range.contains(self)
    }
    public func match(in range: Range<Self>) -> Int {
        return Swift.min(Swift.max(range.lowerBound, self), range.upperBound)
    }
    public func match(from: Self, to: Self) -> Int {
        return Swift.min(Swift.max(from, self), to)
    }
    public func reversed(progress: Int) -> Int {
        return progress - self
    }
}
