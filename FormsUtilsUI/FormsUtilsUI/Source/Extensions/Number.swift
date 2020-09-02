//
//  Number.swift
//  FormsUtils
//
//  Created by Konrad on 3/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import FormsUtils
import UIKit

// MARK: Constant
public extension CGFloat {
    static var greatestConstraintConstant: CGFloat {
        return 100_000
    }
}

public extension String {
    var asCGFloat: CGFloat? { self.asDouble?.asCGFloat }
}

public extension Optional where Wrapped == String {
    var asCGFloat: CGFloat? { self?.asCGFloat }
}

// MARK: CGFloat
extension CGFloat: Number, NumberFormattable {
    public var asBool: Bool { self != 0.0 }
    public var asCGFloat: CGFloat { self }
    public var asDecimal: Decimal { self.asDouble.asDecimal }
    public var asDouble: Double { Double(self) }
    public var asFloat: Float { Float(self) }
    public var asInt: Int { Int(self) }
    public var asNumber: NSNumber { self as NSNumber }
    public var asSize: String? { self.asDouble.asSize }
    public var asString: String { self.asDouble.asString }
    public var isFractional: Bool { true }
    
    public var ceiled: CGFloat { self.rounded(.up) }
    public var floored: CGFloat { self.rounded(.down) }
    
    public var fromDegreesToRadians: CGFloat { self * .pi / 180 }
    public var fromRadiansToDegrees: CGFloat { self * 180 / .pi }
    
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
public extension Double {
    var asCGFloat: CGFloat { CGFloat(self) }
}

// MARK: Int
public extension Int {
    var asCGFloat: CGFloat { CGFloat(self) }
}
