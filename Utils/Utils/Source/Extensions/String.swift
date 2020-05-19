//
//  String.swift
//  Utils
//
//  Created by Konrad on 3/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: String
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
    
    static var empty: String {
        return ""
    }
    
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    var url: URL! {
        return URL(string: self)
    }
    
    func matches(_ string: String,
                 regexOptions: NSRegularExpression.Options = [],
                 matchingOptions: NSRegularExpression.MatchingOptions = []) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: string, options: regexOptions) else { return false }
        let range = NSRange(location: 0, length: self.utf16.count)
        return regex.firstMatch(in: self, options: matchingOptions, range: range) != nil
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

// MARK: String?
public extension Optional where Wrapped == String {
    var emptyAsNil: String? {
        guard self.isNotNilOrEmpty else { return nil }
        return self
    }
    
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

// MARK: Localized
public extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "") // swiftlint:disable:this nslocalizedstring_key
    }
    
    func localized(
        _ locale: Locale = .current,
        _ arguments: CVarArg) -> String {
        return String(format: self.localized, locale: locale, arguments)
    }
}

// MARK: Size
public extension String {
    func height(for width: CGFloat,
                font: UIFont) -> CGFloat {
        let size: CGSize = CGSize(
            width: width,
            height: .greatestFiniteMagnitude)
        let boundingBox: CGRect = self.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(for height: CGFloat,
               font: UIFont) -> CGFloat {
        let size: CGSize = CGSize(
            width: .greatestFiniteMagnitude,
            height: height)
        let boundingBox: CGRect = self.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil)
        return ceil(boundingBox.width)
    }
}

// MARK: String.Element
public extension String.Element {
    var asString: String {
        return String(self)
    }
}
