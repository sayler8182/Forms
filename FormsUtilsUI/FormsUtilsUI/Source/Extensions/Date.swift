//
//  Date.swift
//  FormsUtils
//
//  Created by Konrad on 5/19/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

// MARK: CGFloat
extension CGFloat: FromDateFormattable, ToDateFormattable {
    public var asDate: Date? {
        return Date(timeIntervalSince1970: Double(self))
    }
}
