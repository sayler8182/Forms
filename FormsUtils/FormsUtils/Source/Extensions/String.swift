//
//  String.swift
//  FormsUtils
//
//  Created by Konrad on 3/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

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
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var url: URL! {
        let string: String = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
        return URL(string: string)
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
    
    func truncate(to length: Int,
                  ellips: String? = nil) -> String {
        guard self.count < length else { return self }
        let endPosition: String.Index = self.index(self.startIndex, offsetBy: length)
        let trimmed: String = String(self[..<endPosition])
        guard let ellips: String = ellips else { return trimmed }
        return trimmed.appending(ellips)
    }
}

// MARK: Encoding
public extension String {
    func fromBase64() -> String? {
        guard let data: Data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func decode<T: Decodable>() -> T? {
        let decoder: JSONDecoder = JSONDecoder()
        return try? decoder.decode(T.self, from: self)
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

// MARK: String.Element
public extension String.Element {
    var asString: String {
        return String(self)
    }
}

// MARK: [String]
public extension Collection where Element == String {
    func joined(separator: String,
                skipEmpty: Bool = false) -> String {
        return self
            .filter { $0.isNotEmpty }
            .joined(separator: separator)
    }
}

// MARK: [String?]
public extension Collection where Element == String? {
    func joined(separator: String,
                skipEmpty: Bool = false) -> String {
        return self
            .compactMap { $0 }
            .joined(separator: separator, skipEmpty: skipEmpty)
    }
}
