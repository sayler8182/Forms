//
//  PhoneValidator.swift
//  FormsValidators
//
//  Created by Konrad on 4/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: PhoneValidator
public class PhoneValidator: Validator {
    private let withPrefix: Bool
    
    public init(withPrefix: Bool,
                isRequired: Bool = true) {
        self.withPrefix = withPrefix
        super.init(isRequired: isRequired)
        self.dependencies = [NotEmptyValidator(isRequired: isRequired)]
    }
    
    override public init(isRequired: Bool = true) {
        self.withPrefix = true
        super.init(isRequired: isRequired)
        self.dependencies = [NotEmptyValidator(isRequired: isRequired)]
    }
    
    override public func validate(_ value: Any?) -> ValidationResult {
        let value: String = value as? String ?? ""
        if let result = self.validateDependencies(value) {
            return result
        }
        
        guard self.shouldValidate(value) else { return ValidationResult() }
        let regex: String = self.withPrefix
            ? "^\\+[1-9][0-9]{7,15}"
            : "[0-9]{7,15}"
        guard NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: value) else {
            return ValidationResult(error: .phoneError)
        }
        return ValidationResult()
    }
}
