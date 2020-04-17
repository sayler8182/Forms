//
//  Number.swift
//  Utils
//
//  Created by Konrad on 3/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

#if canImport(Injector)
import Injector
#endif
import UIKit

// MARK: NumberFormatProtocol
public protocol NumberFormatProtocol {
    var groupingSeparator: String { get }
    var decimalSeparator: String { get }
}

public struct NumberFormat: NumberFormatProtocol {
    public var groupingSeparator: String
    public var decimalSeparator: String
    
    public init(groupingSeparator: String,
                decimalSeparator: String) {
        self.groupingSeparator = groupingSeparator
        self.decimalSeparator = decimalSeparator
    }
}

public extension CGFloat {
    static var greatestConstraintConstant: CGFloat {
        return 100_000
    }
}

// MARK: Cast
public extension String {
}

public extension String {
    var asDouble: Double? {
        var string: String = self
        string = string.replacingOccurrences(of: " ", with: "")
        string = string.replacingOccurrences(of: ",", with: ".")
        return Double(string)
    }
}

// MARK: Number
public protocol Number: Comparable {
    var asDouble: Double { get }
    var asNumber: NSNumber { get }
}

public extension Number {
    func currencyNotation(with currency: String? = nil,
                          groupingSeparator: String? = nil,
                          decimalSeparator: String? = nil) -> String {
        let value: NSNumber = self.asDouble as NSNumber
        let formatter: NumberFormatter = NumberFormatter()
        #if canImport(Injector)
        let numberFormat: NumberFormatProtocol? = Injector.main.resolve(NumberFormatProtocol.self)
        formatter.groupingSeparator = groupingSeparator ?? numberFormat?.groupingSeparator ?? ","
        formatter.decimalSeparator = decimalSeparator ?? numberFormat?.decimalSeparator ?? ","
        #else
        formatter.groupingSeparator = groupingSeparator ?? ","
        formatter.decimalSeparator = decimalSeparator ?? ","
        #endif
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        var string: String? = formatter.string(from: value)
        if let currency: String = currency {
            string?.append(currency)
        }
        return string.or("")
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

// MARK: Number
public extension Optional where Wrapped == String {
    var asDouble: Double? { self?.asDouble }
    var asNumber: NSNumber? { self?.asDouble?.asNumber }
}
extension CGFloat: Number {
    public var asDouble: Double { Double(self) }
    public var asNumber: NSNumber { self as NSNumber }
}
extension Double: Number {
    public var asDouble: Double { self }
    public var asNumber: NSNumber { self as NSNumber }
}
extension Int: Number {
    public var asDouble: Double { Double(self) }
    public var asNumber: NSNumber { self as NSNumber }
}
