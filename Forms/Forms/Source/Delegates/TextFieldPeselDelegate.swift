//
//  TextFieldPeselDelegate.swift
//  Forms
//
//  Created by Konrad on 4/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: TextFieldPeselDelegate
public class TextFieldPeselDelegate: TextFieldDelegate {
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        guard string.isNotEmpty else { return true }
        var text: String = textField.text.or("").shouldChangeCharactersIn(range, replacementString: string)
        text = text.lowercased()
        let regex: String = "^[0-9]+$"
        guard NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text) else {
            return false
        }
        return true
    }
}
