//
//  String.swift
//  Utils
//
//  Created by Konrad on 3/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

public extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let minValue: Int = 0
        let maxValue: Int = self.count
        var lowerBound: Int = range.lowerBound
        var upperBound: Int = range.upperBound
        if lowerBound > maxValue { return "" }
        if lowerBound < minValue { lowerBound = minValue }
        if upperBound > maxValue { upperBound = maxValue }
        if upperBound < minValue { return "" }
        let indexMin: Index = self.index(self.startIndex, offsetBy: lowerBound)
        let indexMax: Index = self.index(self.startIndex, offsetBy: upperBound)
        return String(self[indexMin..<indexMax])
    }
    
    subscript(_ i: Int) -> String {
        get { return self[i..<i + 1] }
        set {
            guard i + newValue.count <= self.count else { return }
            guard i >= 0 else { return }
            let indexMin: Index = self.index(self.startIndex, offsetBy: i)
            let indexMax: Index = self.index(self.startIndex, offsetBy: newValue.count)
            self.replaceSubrange(indexMin..<indexMax, with: newValue)
        }
    }
    
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    func shouldChangeCharactersIn(_ range: NSRange,
                                  replacementString string: String) -> String {
        var text: String = self
        text.insert(
            contentsOf: string,
            at: text.index(
                text.startIndex,
                offsetBy: range.location))
        return text
    }
}

public extension Optional where Wrapped == String {
    var orEmpty: String {
        guard let value: String = self else { return "" }
        return value
    }
    
    var isEmpty: Bool {
        guard let value: String = self else { return false }
        guard !value.isEmpty else { return true }
        return false
    }
    
    var isNilOrEmpty: Bool {
        guard let value: String = self else { return true }
        guard !value.isEmpty else { return true }
        return false
    }
    
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    var isNotNilOrEmpty: Bool {
        return !self.isNilOrEmpty
    }
}
