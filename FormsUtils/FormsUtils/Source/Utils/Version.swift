//
//  Version.swift
//  FormsUtils
//
//  Created by Konrad on 8/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: Version
public struct Version: Equatable, Comparable {
    private var version: String
    
    public var description: String {
        return self.version
    }
    
    public init?(_ version: String?) {
        guard let version: String = version else { return nil }
        self.init(version)
    }
    
    public init(_ version: String) {
        self.version = version
    }
    
    public func isEqual(_ version: Version?) -> Bool {
        guard let version: String = version?.version else { return false }
        return version.compare(self.version, options: String.CompareOptions.numeric) == .orderedSame
    }
    
    public func isGreater(_ version: Version?) -> Bool {
        guard let version: String = version?.version else { return false }
        return version.compare(self.version, options: String.CompareOptions.numeric) == .orderedAscending
    }
    
    public func isLower(_ version: Version?) -> Bool {
        guard let version: String = version?.version else { return false }
        return version.compare(self.version, options: String.CompareOptions.numeric) == .orderedDescending
    }
    
    public static func == (lhs: Version, rhs: Version) -> Bool {
        return lhs.isEqual(rhs)
    }
    
    public static func < (lhs: Version, rhs: Version) -> Bool {
        return lhs.isLower(rhs)
    }
    
    public static func > (lhs: Version, rhs: Version) -> Bool {
        return lhs.isGreater(rhs)
    }
    
    public static func < (lhs: Version, rhs: Version?) -> Bool {
        return lhs.isLower(rhs)
    }
    
    public static func > (lhs: Version, rhs: Version?) -> Bool {
        return lhs.isGreater(rhs)
    }
    
    public static func <= (lhs: Version, rhs: Version?) -> Bool {
        return lhs.isLower(rhs) || lhs.isEqual(rhs)
    }
    
    public static func >= (lhs: Version, rhs: Version?) -> Bool {
        return lhs.isGreater(rhs) || lhs.isEqual(rhs)
    }
}

// MARK: String
public extension String {
    var asVersion: Version? {
        return Version(self)
    }
}
