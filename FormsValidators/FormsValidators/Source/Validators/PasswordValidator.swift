//
//  PasswordValidator.swift
//  FormsValidators
//
//  Created by Konrad on 6/20/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: PasswordValidator
public class PasswordValidator: Validator {
    public enum Strength {
        case weak
        case regular
        case strong
    }
    
    private let strength: Strength
    
    public init(strength: Strength,
                isRequired: Bool = true) {
        self.strength = strength
        super.init(isRequired: isRequired)
        self.dependencies = [NotEmptyValidator(isRequired: isRequired)]
    }
    
    override public init(isRequired: Bool = true) {
        self.strength = Strength.regular
        super.init(isRequired: isRequired)
        self.dependencies = [NotEmptyValidator(isRequired: isRequired)]
    }
    
    override public func validate(_ value: Any?) -> ValidationResult {
        let value: String = value as? String ?? ""
        if let result = self.validateDependencies(value) {
            return result
        }
        
        guard self.shouldValidate(value) else { return ValidationResult() }
        switch self.strength {
        case .weak:
            return self.validateWeak(value)
        case .regular:
            return self.validateRegular(value)
        case .strong:
            return self.validateStrong(value)
        }
    }
    
    private func validateWeak(_ value: String) -> ValidationResult {
        guard 4 <= value.count else {
            return ValidationResult(error: .passwordError)
        }
        return ValidationResult()
    }
    
    private func validateRegular(_ value: String) -> ValidationResult {
        guard 8 <= value.count else {
            return ValidationResult(error: .passwordError)
        }
        return ValidationResult()
    }
    
    private func validateStrong(_ value: String) -> ValidationResult {
        guard 12 <= value.count else {
            return ValidationResult(error: .passwordError)
        }
        return ValidationResult()
    }
}
