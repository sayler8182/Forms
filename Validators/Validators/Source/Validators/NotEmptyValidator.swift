//
//  NotEmptyValidator.swift
//  Validators
//
//  Created by Konrad on 4/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: NotEmptyValidator
public class NotEmptyValidator: Validator {
    override public func validate(_ value: Any?) -> ValidationResult {
        let value: String = value as? String ?? ""
        guard self.shouldValidate(value) else { return ValidationResult() }
        guard !value.isEmpty else {
            return ValidationResult(error: .notEmptyError)
        }
        return ValidationResult()
    }
}
