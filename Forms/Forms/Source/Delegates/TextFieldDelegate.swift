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
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
