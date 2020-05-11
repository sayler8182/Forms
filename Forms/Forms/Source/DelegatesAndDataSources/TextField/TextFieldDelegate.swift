//
//  TextFieldDelegate.swift
//  Forms
//
//  Created by Konrad on 4/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TextFieldDelegate
public class TextFieldDelegate: NSObject, UITextFieldDelegate {
    public func textFieldDidPaste(_ textField: UITextField,
                                  string: String) -> Bool {
        guard let textField = textField.formTextField else { return false }
        let pasteboard: String = UIPasteboard.general.string ?? ""
        guard string.contains(pasteboard) else { return false }
        textField.validatorTrigger()
        textField.onDidPaste?(string, pasteboard)
        return true
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
