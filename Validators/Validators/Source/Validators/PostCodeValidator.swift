//
//  PostCodeValidator.swift
//  Validators
//
//  Created by Konrad on 5/7/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: PostCodeValidator
public class PostCodeValidator: Validator {
    private let format: PostCodeFormat
    
    public init(format: PostCodeFormat = PostCodeFormat(),
                isRequired: Bool = true) {
        self.format = format
        super.init(isRequired: isRequired)
        self.dependencies = [NotEmptyValidator(isRequired: isRequired)]
    }
     
    override public func validate(_ value: Any?) -> ValidationResult {
        let value: String = value as? String ?? ""
        if let result = self.validateDependencies(value) {
            return result
        }
        
        guard self.shouldValidate(value) else { return ValidationResult() }
        guard self.format.isValid(value) else {
            return ValidationResult(error: .postCodeError)
        }
        return ValidationResult()
    }
}

// MARK: String
public struct PostCodeFormat {
    public let format: String
    
    public init(_ format: String = "XX-XXX") {
        self.format = format
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
            guard formatChar != "X" else { continue }
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
                guard formatChar != "X" else { continue }
                string[i] = formatChar
            }
            let count = formatCount - index
            for i in 0..<count {
                let formatChar: String = self.format[index + i]
                guard formatChar != "X" else { break }
                string.append(formatChar)
            }
        }
        return string.joined()
    }
    
    public func isValid(_ string: String?) -> Bool {
        let actualFormat = string.or("")
            .map { $0.isNumber ? "X" : String($0) }
            .joined()
        return actualFormat == self.format
    }
}
