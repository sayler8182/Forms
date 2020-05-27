//
//  FormatValidator.swift
//  Validators
//
//  Created by Konrad on 5/7/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: FormatValidator
public class FormatValidator: Validator {
    public let format: FormatProtocol
    
    public var formatError: ValidationError {
        return .formatError(self.format)
    }
    
    public init(format: FormatProtocol,
                isRequired: Bool = true) {
        self.format = format
        super.init(isRequired: isRequired)
        self.dependencies = [NotEmptyValidator(isRequired: isRequired)]
    }
    
    public func isFormatValid(_ string: String) -> Bool {
        return true
    }
     
    override public func validate(_ value: Any?) -> ValidationResult {
        let value: String = value as? String ?? ""
        if let result = self.validateDependencies(value) {
            return result
        }
        
        guard self.shouldValidate(value) else { return ValidationResult() }
        guard self.format.isValid(value) && self.isFormatValid(value) else {
            return ValidationResult(error: self.formatError)
        }
        return ValidationResult()
    }
}

// MARK: FormatProtocol
public protocol FormatProtocol {
    var format: String { get }
    var formatChars: [String] { get }
    
    func replace(with range: NSRange,
                 in string: String) -> String
    func formatText(_ string: String) -> String
    func isValid(_ string: String?) -> Bool
}

// MARK: String
public class Format: FormatProtocol {
    public let format: String
    public let formatChars: [String]
    
    public init(_ format: String,
                formatChars: [String] = ["D"]) {
        self.format = format
        self.formatChars = formatChars
    }
    
    public func replace(with range: NSRange,
                        in string: String) -> String {
        let formatCount: Int = self.format.count
        var string: [String] = string
            .map { String($0) }
            .enumerated()
            .filter { $0.offset < formatCount }
            .map { $0.element }
        for i in 0...range.length {
            let index: Int = range.location + i
            let formatChar: String = self.format[index]
            guard formatChar.isNotEmpty else { break }
            guard !self.isFormatChars(formatChar) else { continue }
            string[index] = formatChar
        }
        return string.joined()
    }
    
    public func formatText(_ string: String) -> String {
        let formatCount: Int = self.format.count
        var string: [String] = string
            .map { String($0) }
            .enumerated()
            .filter { $0.offset < formatCount }
            .map { $0.element }
        let index: Int = string.count
        if index <= formatCount {
            for i in 0..<index {
                let formatChar: String = self.format[i]
                guard formatChar.isNotEmpty else { break }
                guard !self.isFormatChars(formatChar) else { continue }
                string[i] = formatChar
            }
            let count = formatCount - index
            for i in 0..<count {
                let formatChar: String = self.format[index + i]
                guard !self.isFormatChars(formatChar) else { break }
                string.append(formatChar)
            }
        }
        return string.joined()
    }
    
    public func isValid(_ string: String?) -> Bool {
        guard let string: String = string else { return false }
        guard string.count == self.format.count else { return false }
        for i in 0..<string.count {
            let char: String = string[i]
            let formatChar: String = self.format[i]
            guard self.isFormatChars(formatChar) else { continue }
            if formatChar == "D" {
                guard char.isNumber else { return false }
            } 
        }
        return true
    }
    
    private func isFormatChars(_ formatChar: String) -> Bool {
        return self.formatChars.contains(formatChar)
    }
}
