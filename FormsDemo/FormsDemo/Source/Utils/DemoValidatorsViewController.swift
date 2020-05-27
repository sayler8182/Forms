//
//  DemoValidatorsViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit
import Validators

// MARK: DemoValidatorsViewController
class DemoValidatorsViewController: FormsTableViewController {
    private let amountTextField = Components.input.textField.amount.default()
        .with(title: "AmountValidator")
        .with(validator: AmountValidator(minAmount: 100, maxAmount: 20_000, currency: "PLN"))
        .with(validateOnTextChange: true)
    private let emailTextField = Components.input.textField.email.default()
        .with(title: "EmailValidator")
        .with(validator: EmailValidator())
        .with(validateOnEndEditing: true)
    private let lengthTextField = Components.input.textField.default()
        .with(title: "LengthValidator")
        .with(validator: LengthValidator(minLength: 1, maxLength: 20))
        .with(validateOnTextChange: true)
    private let notEmptyTextField = Components.input.textField.default()
        .with(title: "NotEmptyValidator")
        .with(validator: NotEmptyValidator())
    private let peselTextField = Components.input.textField.pesel.default()
        .with(title: "PeselValidator")
        .with(validator: PeselValidator(isRequired: false))
        .with(validateOnEndEditing: true)
    private let phoneTextField = Components.input.textField.phone.default()
        .with(title: "PhoneValidator")
        .with(validator: PhoneValidator(isRequired: false))
        .with(validateOnEndEditing: true)
    private let postCodeTextField = Components.input.textField.postCode.default()
        .with(title: "PostCodeValidator")
        .with(validator: PostCodeValidator())
        .with(validateOnEndEditing: true)
    private let dateTextField = Components.input.textField.date.default()
        .with(title: "DateValidator")
        .with(validator: DateValidator())
        .with(validateOnTextChange: true)
    private let formatTextField = Components.input.textField.format.default()
        .with(maskText: "DD-DD-DD")
        .with(title: "FormatValidator")
        .with(validator: FormatValidator(format: Format("DD-DD-DD")))
        .with(validateOnTextChange: true)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.amountTextField,
            self.emailTextField,
            self.lengthTextField,
            self.notEmptyTextField,
            self.peselTextField,
            self.phoneTextField,
            self.postCodeTextField,
            self.dateTextField,
            self.formatTextField
        ], divider: self.divider)
    }
    
    override func setupOther() {
        super.setupOther()
        self.amountTextField.textFieldDelegate(of: TextFieldAmountDelegate.self)?
            .configure(currency: "PLN", maxValue: 100_000, maxFraction: 4)
        self.formatTextField.textFieldDelegate(of: TextFieldFormatDelegate.self)?
            .configure(format: "DD-DD-DD")
    }
}
