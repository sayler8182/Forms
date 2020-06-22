//
//  CGPoint.swift
//  FormsUtils
//
//  Created by Konrad on 6/5/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: Operators
public extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs + rhs // swiftlint:disable:this shorthand_operator
    }
    
    static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs - rhs // swiftlint:disable:this shorthand_operator
    }
}
