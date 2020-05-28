//
//  PeselValidator.swift
//  FormsValidators
//
//  Created by Konrad on 4/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: PeselValidator
public class PeselValidator: Validator {
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
        if let charactersResult = self.validateCharacters(pesel: value) {
            return charactersResult
        }
        if let lengthResult = self.validateLength(pesel: value) {
            return lengthResult
        }
        if let dateResult = self.validateDate(pesel: value) {
            return dateResult
        }
        if let checkSumResult = self.validateCheckSum(pesel: value) {
            return checkSumResult
        }
        return ValidationResult()
    }
    
    private func validateCharacters(pesel: String) -> ValidationResult? {
        let regex: String = "^[0-9]+$"
        guard NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: pesel) else {
            return ValidationResult(error: .peselError)
        }
        return nil
    }
    
    private func validateLength(pesel: String) -> ValidationResult? {
        switch pesel.count {
        case ..<11: return ValidationResult(error: .peselShortError)
        case 12...: return ValidationResult(error: .peselLongError)
        default: return nil
        }
    }
    
    private func validateDate(pesel: String) -> ValidationResult? {
        guard let year: Int = Int(pesel[2..<4]),
            let month: Int = Int(pesel[2..<4]),
            let day: Int = Int(pesel[4..<6]) else {
                return ValidationResult(error: .peselError)
        }
        var date: (day: Int, month: Int, year: Int) = (0, 0, 0)
        switch  month {
        case 1...12: date = (day, month, 1_900 + year)
        case 21...32: date = (day, month - 20, 2_000 + year)
        case 41...52: date = (day, month - 40, 2_100 + year)
        case 61...72: date = (day, month - 60, 2_200 + year)
        case 81...92: date = (day, month - 80, 1_800 + year)
        default: break
        }
        
        let components = DateComponents(
            year: date.year,
            month: date.month,
            day: date.day)
        guard let calendarDate: Date = Calendar(identifier: .gregorian).date(from: components),
            calendarDate.timeIntervalSinceNow < 0 else {
                return ValidationResult(error: .peselError)
        }
        return nil
    }
    
    private func validateCheckSum(pesel: String) -> ValidationResult? {
        guard let crc: Int = Int(pesel[10]) else {
            return ValidationResult(error: .peselError)
        }
        var controlNumber: Int = 0
        let weights: [Int] = [9, 7, 3, 1, 9, 7, 3, 1, 9, 7]
        for i in 0..<pesel.count - 1 {
            guard let value: Int = Int(pesel[i]) else {
                return ValidationResult(error: .peselError)
            }
            controlNumber += weights[i] * value
        }
        controlNumber = controlNumber % 10
        guard crc == controlNumber else {
            return ValidationResult(error: .peselError)
        }
        return nil
    }
}
