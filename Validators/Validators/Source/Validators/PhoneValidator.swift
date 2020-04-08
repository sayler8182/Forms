//
//  PhoneValidator.swift
//  Validators
//
//  Created by Konrad on 4/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

public class PhoneValidator: Validator {
    override public init(isRequired: Bool = true) {
        super.init(isRequired: isRequired)
        self.dependencies = [NotEmptyValidator(isRequired: isRequired)]
    }
    
    override public func validate(_ value: Any?) -> ValidationResult {
        let value: String = value as? String ?? ""
        if let result = self.validateDependencies(value) {
            return result
        }
        
        guard self.shouldValidate(value) else { return ValidationResult() }
        let regex: String = "^\\+[1-9][0-9]{7,15}"
        guard NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: value) else {
            return ValidationResult(error: .phoneError)
        }
        return ValidationResult()
    }
}
