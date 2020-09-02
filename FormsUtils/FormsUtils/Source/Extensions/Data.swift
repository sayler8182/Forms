//
//  Data.swift
//  FormsUtils
//
//  Created by Konrad on 8/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: Data
public extension Data {
    var string: String {
        return self
            .map { String(format: "%02X", $0) }
            .joined()
    }
}
