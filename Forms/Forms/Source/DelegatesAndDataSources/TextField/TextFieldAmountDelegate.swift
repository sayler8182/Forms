//
//  TextFieldAmountDelegate.swift
//  Forms
//
//  Created by Konrad on 3/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TextFieldAmountDelegate
public class TextFieldAmountDelegate: TextFieldDelegate {
    private var currency: String? = nil
    private var minValue: Double? = nil
    private var maxValue: Double? = nil
    private var maxDecimal: Int = 12
    private var maxFraction: Int = 2
    
    override public init() {
        super.init()
        self.configure()
    }
    
    public func configure(currency: String? = nil,
                          minValue: Double? = nil,
                          maxValue: Double? = nil,
                          maxDecimal: Int = 12,
                          maxFraction: Int = 2) {
        self.currency = currency
        self.minValue = minValue
        self.maxValue = maxValue
        self.maxDecimal = maxDecimal
        self.maxFraction = maxFraction
    }
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        guard string.isNotEmpty else { return true }
        let text: String = textField.text.or("").shouldChangeCharactersIn(range, replacementString: string)
        guard self.validateFormat(text: text) else { return false }
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        var text: String? = textField.text
        text = self.normalizeText(text: text)
        let amount: Double = text.asDouble.or(0)
        textField.text = amount != 0 ? text : ""
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        var amount: Double = textField.text.asDouble.or(0)
        amount = self.normalizeValue(double: amount)
        textField.text = amount.currencyNotation(with: self.currency)
    }
    
    private func validateFormat(text: String) -> Bool {
        let text = text.replacingOccurrences(of: ",", with: ".")
        let parts: [String] = text.components(separatedBy: ".")
        if parts.count > self.maxFraction { return false }
        if parts[0].count > self.maxDecimal { return false }
        if parts.count > 1 && parts[1].count > self.maxFraction { return false }
        return true
    }
    
    private func normalizeText(text: String?) -> String? {
        guard var text: String = text else { return nil }
        text = text.replacingOccurrences(of: ",", with: ".")
        if let currency: String = self.currency,
            text.hasSuffix(currency) {
            text.removeLast(currency.count)
        }
        if text.hasSuffix(".00") {
            text.removeLast(3)
        }
        return text
    }
    
    private func normalizeValue(double: Double?) -> Double {
        guard let double: Double = double else { return 0.0 }
        if let minValue: Double = self.minValue,
            double < minValue {
            return minValue
        }
        if let maxValue: Double = self.maxValue,
            double > maxValue {
            return maxValue
        }
        return double
    }
}
