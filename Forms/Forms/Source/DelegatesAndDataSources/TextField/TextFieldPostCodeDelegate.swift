//
//  TextFieldPostCodeDelegate.swift
//  Forms
//
//  Created by Konrad on 5/7/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit
import Validators

// MARK: TextFieldPostCodeDelegate
public class TextFieldPostCodeDelegate: TextFieldDelegate {
    public var format: PostCodeFormat = PostCodeFormat()
     
    override public init() {
        super.init()
        self.configure()
    }
    
    public func configure(format: PostCodeFormat = PostCodeFormat()) {
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
