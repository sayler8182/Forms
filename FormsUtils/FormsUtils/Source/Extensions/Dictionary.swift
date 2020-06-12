//
//  Dictionary.swift
//  FormsUtils
//
//  Created by Konrad on 6/12/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: Dictionary
public extension Dictionary {
    var prettyPrinted: String? {
        guard let data: Data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
