//
//  StringValidator.swift
//  FormsValidators
//
//  Created by Konrad on 6/20/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: StringValidator
public class StringValidator: Validator {
    public enum CharactersSet {
        case alphanumeric
        case numeric
        case text
        case regex(String)
        
        fileprivate var _regex: String {
            switch self {
            case .alphanumeric: return "^[\(alphaCharacters)0-9]+$"
            case .numeric: return "^[0-9]+$"
            case .text: return "^[\(alphaCharacters)]+$"
            case .regex(let regex): return regex
            }
        }
    }
    
    private let set: CharactersSet?
    
    public init(set: CharactersSet,
                isRequired: Bool = true) {
        self.set = set
        super.init(isRequired: isRequired)
        self.dependencies = [NotEmptyValidator(isRequired: isRequired)]
    }
    
    override public init(isRequired: Bool = true) {
        self.set = nil
        super.init(isRequired: isRequired)
        self.dependencies = [NotEmptyValidator(isRequired: isRequired)]
    }
    
    override public func validate(_ value: Any?) -> ValidationResult {
        let value: String = value as? String ?? ""
        if let result = self.validateDependencies(value) {
            return result
        }
        
        guard self.shouldValidate(value) else { return ValidationResult() }
        let regex: String = self.set?._regex ?? ""
        guard NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: value) else {
            return ValidationResult(error: .stringError)
        }
        return ValidationResult()
    }
}
