//
//  EmailValidator.swift
//  FormsValidators
//
//  Created by Konrad on 4/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: EmailValidator
public class EmailValidator: Validator {
    override public init(isRequired: Bool = true) {
        super.init(isRequired: isRequired)
        self.dependencies = [NotEmptyValidator(isRequired: isRequired)]
    }
    
    override public func validate(_ value: Any?) -> ValidationResult {
        var value: String = value as? String ?? ""
        if let result = self.validateDependencies(value) {
            return result
        }
        
        guard self.shouldValidate(value) else { return ValidationResult() }
        value = value.lowercased()
        let regex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        guard NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: value) else {
            return ValidationResult(error: .emailError)
        }
        return ValidationResult()
    }
}
