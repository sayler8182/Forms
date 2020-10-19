//
//  Number.swift
//  FormsUtils
//
//  Created by Konrad on 3/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import Foundation

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

// MARK: String
public extension String {
    var isNumber: Bool {
        return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

public extension String {
    var asBool: Bool? { self.asDouble?.asBool }
    var asDecimal: Decimal? { self.asDouble?.asDecimal }
    var asDouble: Double? {
        let string: String = self
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: ".")
        return Double(string)
    }
    var asFloat: Float? { self.asDouble?.asFloat }
    var asInt: Int? { self.asDouble?.asInt }
    var asNumber: NSNumber? { self.asDouble?.asNumber }
    var asSize: String? { self.asDouble?.asSize }
    var asString: String { self }
    var isFractional: Bool { self.contains(".") }
}

public extension Optional where Wrapped == String {
    var asBool: Bool? { self?.asBool }
    var asDecimal: Decimal? { self?.asDecimal }
    var asDouble: Double? { self?.asDouble }
    var asFloat: Float? { self?.asDouble?.asFloat }
    var asInt: Int? { self?.asInt }
    var asNumber: NSNumber? { self?.asNumber }
    var asSize: String? { self?.asDouble?.asSize }
    var asString: String? { self?.asString }
    var isFractional: Bool? { self?.isFractional }
}

// MARK: Number
public protocol Number: Comparable {
    var asBool: Bool { get }
    var asDecimal: Decimal { get }
    var asDouble: Double { get }
    var asFloat: Float { get }
    var asInt: Int { get }
    var asNumber: NSNumber { get }
    var asString: String { get }
    var asSize: String? { get }
    var isFractional: Bool { get }
    
    var ceiled: Self { get }
    var floored: Self { get }
    
    var fromDegreesToRadians: Self { get }
    var fromRadiansToDegrees: Self { get }
    
    func inRange(_ range: Range<Self>) -> Bool
    func inRange(_ range: ClosedRange<Self>) -> Bool
    func match(in range: Range<Self>) -> Self
    func match(from: Self, to: Self) -> Self
    func reversed(progress: Self) -> Self
    func multiplication(_ value: Self) -> Self
    func division(_ value: Self) -> Self
    func addition(_ value: Self) -> Self
    func subtraction(_ value: Self) -> Self
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
        let numberFormat: NumberFormatProtocol? = Injector.main.resolveOrDefault("FormsUtils")
        kNumberFormatter.groupingSeparator = groupingSeparator ?? numberFormat?.groupingSeparator ?? " "
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

// MARK: Double
extension Double: Number, NumberFormattable {
    public var asBool: Bool { self != 0.0 }
    public var asDecimal: Decimal { Decimal(self) }
    public var asDouble: Double { self }
    public var asFloat: Float { Float(self) }
    public var asInt: Int { Int(self) }
    public var asNumber: NSNumber { self as NSNumber }
    public var asString: String { String(self) }
    public var asSize: String? {
        let scale: Double = 1_024.0
        if self < scale {
            return String(format: "%3.2f B", self)
        } else if self < scale * scale {
            return String(format: "%3.2f kB", self / scale)
        } else if self < scale * scale * scale {
            return String(format: "%3.2f MB", self / (scale * scale))
        } else if self < scale * scale * scale * scale {
            return String(format: "%3.2f GB", self / (scale * scale * scale))
        } else if self < scale * scale * scale * scale * scale {
            return String(format: "%3.2f TB", self / (scale * scale * scale * scale))
        } else {
            return nil
        }
    }
    public var isFractional: Bool { true }
    
    public var ceiled: Double { self.rounded(.up) }
    public var floored: Double { self.rounded(.down) }
    
    public var fromDegreesToRadians: Double { self * .pi / 180 }
    public var fromRadiansToDegrees: Double { self * 180 / .pi }
    
    public func inRange(_ range: Range<Self>) -> Bool {
        return range.contains(self)
    }
    public func inRange(_ range: ClosedRange<Self>) -> Bool {
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
    public func multiplication(_ value: Double) -> Double {
        return self * value
    }
    public func division(_ value: Double) -> Double {
        return self / value
    }
    public func addition(_ value: Double) -> Double {
        return self + value
    }
    public func subtraction(_ value: Double) -> Double {
        return self - value
    }
}

// MARK: Float
extension Float: Number, NumberFormattable {
    public var asBool: Bool { self != 0 }
    public var asDecimal: Decimal { Decimal(self.asDouble) }
    public var asDouble: Double { Double(self) }
    public var asFloat: Float { self }
    public var asInt: Int { Int(self) }
    public var asNumber: NSNumber { self as NSNumber }
    public var asSize: String? { self.asDouble.asSize }
    public var asString: String { String(self) }
    public var isFractional: Bool { false }
    
    public var ceiled: Float { self.asDouble.rounded(.up).asFloat }
    public var floored: Float { self.asDouble.rounded(.down).asFloat }
    
    public var fromDegreesToRadians: Float { self.asDouble.fromDegreesToRadians.asFloat }
    public var fromRadiansToDegrees: Float { self.asDouble.fromRadiansToDegrees.asFloat }
    
    public func inRange(_ range: Range<Self>) -> Bool {
        return range.contains(self)
    }
    public func inRange(_ range: ClosedRange<Self>) -> Bool {
        return range.contains(self)
    }
    public func match(in range: Range<Self>) -> Float {
        return Swift.min(Swift.max(range.lowerBound, self), range.upperBound)
    }
    public func match(from: Self, to: Self) -> Float {
        return Swift.min(Swift.max(from, self), to)
    }
    public func reversed(progress: Float) -> Float {
        return progress - self
    }
    public func multiplication(_ value: Float) -> Float {
        return self * value
    }
    public func division(_ value: Float) -> Float {
        return self / value
    }
    public func addition(_ value: Float) -> Float {
        return self + value
    }
    public func subtraction(_ value: Float) -> Float {
        return self - value
    }
}

// MARK: Int
extension Int: Number, NumberFormattable {
    public var asBool: Bool { self != 0 }
    public var asDecimal: Decimal { Decimal(self) }
    public var asDouble: Double { Double(self) }
    public var asFloat: Float { Float(self) }
    public var asInt: Int { self }
    public var asNumber: NSNumber { self as NSNumber }
    public var asSize: String? { self.asDouble.asSize }
    public var asString: String { String(self) }
    public var isFractional: Bool { false }
    
    public var ceiled: Int { self }
    public var floored: Int { self }
    
    public var fromDegreesToRadians: Int { self.asDouble.fromDegreesToRadians.asInt }
    public var fromRadiansToDegrees: Int { self.asDouble.fromRadiansToDegrees.asInt }
    
    public func inRange(_ range: Range<Self>) -> Bool {
        return range.contains(self)
    }
    public func inRange(_ range: ClosedRange<Self>) -> Bool {
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
    public func multiplication(_ value: Int) -> Int {
        return self * value
    }
    public func division(_ value: Int) -> Int {
        return self / value
    }
    public func addition(_ value: Int) -> Int {
        return self + value
    }
    public func subtraction(_ value: Int) -> Int {
        return self - value
    }
}
