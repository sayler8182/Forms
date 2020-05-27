//
//  TextFieldFormatDelegate.swift
//  Forms
//
//  Created by Konrad on 5/7/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit
import Validators

// MARK: TextFieldFormatDelegate
public class TextFieldFormatDelegate: TextFieldDelegate {
    public var format: FormatProtocol = Format("")
     
    public init(format: FormatProtocol) {
        super.init()
        self.configure(format: format)
    }
    
    public init(format: String) {
        super.init()
        let format: FormatProtocol = Format(format)
        self.configure(format: format)
    }
     
    public func configure(format: String) {
        self.format = Format(format)
    }
    
    public func configure(format: FormatProtocol) {
        self.format = format
    }
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        guard string.isNotEmpty else { return true }
        var text: String = textField.text.or("").shouldChangeCharactersIn(range, replacementString: string)
        text = self.format.replace(with: range, in: text)
        text = self.format.formatText(text)
        textField.text = text
        textField.sendActions(for: .editingChanged)
        return false
    }
}
