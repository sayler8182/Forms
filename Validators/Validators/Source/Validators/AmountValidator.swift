//
//  AmountValidator.swift
//  Validators
//
//  Created by Konrad on 4/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation
import Utils

// MARK: AmountValidator
public class AmountValidator: Validator {
    private let currency: String?
    private let minAmount: Double?
    private let maxAmount: Double?
    
    public init(minAmount: Double,
                currency: String? = nil,
                isRequired: Bool = true) {
        self.minAmount = minAmount
        self.maxAmount = nil
        self.currency = currency
        super.init(isRequired: isRequired)
    }
    
    public init(maxAmount: Double,
                currency: String? = nil,
                isRequired: Bool = true) {
        self.minAmount = nil
        self.maxAmount = maxAmount
        self.currency = currency
        super.init(isRequired: isRequired)
    }
    
    public init(minAmount: Double,
                maxAmount: Double,
                currency: String? = nil,
                isRequired: Bool = true) {
        self.minAmount = minAmount
        self.maxAmount = maxAmount
        self.currency = currency
        super.init(isRequired: isRequired)
    }
    
    override public func validate(_ value: Any?) -> ValidationResult {
        var value: String = value as? String ?? ""
        if let currency: String = self.currency,
            value.hasSuffix(currency) {
            value.removeLast(currency.count)
        }
        guard self.shouldValidate(value) else { return ValidationResult() }
        guard let amount: Double = value.asDouble else {
            return ValidationResult(error: .amountError)
        }
        if let minAmount: Double = self.minAmount,
            amount < minAmount {
            return ValidationResult(error: .amountMinError(minAmount.currencyNotation(with: self.currency)))
        }
        if let maxAmount: Double = self.maxAmount,
            amount > maxAmount {
            return ValidationResult(error: .amountMaxError(maxAmount.currencyNotation(with: self.currency)))
        }
        return ValidationResult()
    }
}
