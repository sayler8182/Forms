//
//  LengthValidator.swift
//  Validators
//
//  Created by Konrad on 4/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

public class LengthValidator: Validator {
    private let minLength: Int?
    private let maxLength: Int?
    
    public init(minLength: Int,
                isRequired: Bool = true) {
        self.minLength = minLength
        self.maxLength = nil
        super.init(isRequired: isRequired)
    }
    
    public init(maxLength: Int,
                isRequired: Bool = true) {
        self.minLength = nil
        self.maxLength = maxLength
        super.init(isRequired: isRequired)
    }
    
    public init(minLength: Int,
                maxLength: Int,
                isRequired: Bool = true) {
        self.minLength = minLength
        self.maxLength = maxLength
        super.init(isRequired: isRequired)
    }
    
    override public func validate(_ value: Any?) -> ValidationResult {
        let value: String = value as? String ?? ""
        guard self.shouldValidate(value) else { return ValidationResult() }
        if let minLength: Int = self.minLength,
            value.count < minLength {
            return ValidationResult(error: .lengthMinError(minLength.description))
        }
        if let maxLength: Int = self.maxLength,
            value.count > maxLength {
            return ValidationResult(error: .lengthMaxError(maxLength.description))
        }
        return ValidationResult()
    }
}
