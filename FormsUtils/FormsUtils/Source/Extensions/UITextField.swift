//
//  UITextField.swift
//  FormsUtils
//
//  Created by Konrad on 5/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UITextField
public extension UITextField {
    func setBeginTextFocus() {
        self.selectedTextRange = self.textRange(from: self.beginningOfDocument, to: self.beginningOfDocument)
    }
    
    func setEndTextFocus() {
        self.selectedTextRange = self.textRange(from: self.endOfDocument, to: self.endOfDocument)
    }
}
