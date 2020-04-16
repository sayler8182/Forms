//
//  ComponentsInputs.swift
//  Forms
//
//  Created by Konrad on 3/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public struct ComponentsInputs: ComponentsList {
    private init() { }
    
    public static func titleAmountTextField() -> TitleTextField {
        let component = ComponentsInputs.titleTextField()
        component.keyboardType = .numberPad
        component.textFieldDelegate = TextFieldDelegates.amount()
        return component
    }
    
    public static func titleEmailTextField() -> TitleTextField {
        let component = ComponentsInputs.titleTextField()
        component.autocapitalizationType = .none
        component.autocorrectionType = .no
        component.keyboardType = .emailAddress
        component.textFieldDelegate = TextFieldDelegates.email()
        return component
    }
    
    public static func titlePeselTextField() -> TitleTextField {
        let component = ComponentsInputs.titleTextField()
        component.keyboardType = .numberPad
        component.textFieldDelegate = TextFieldDelegates.pesel()
        return component
    }
    
    public static func titlePhoneTextField() -> TitleTextField {
        let component = ComponentsInputs.titleTextField()
        component.keyboardType = .phonePad
        component.textFieldDelegate = TextFieldDelegates.phone()
        return component
    }
    
    public static func titleTextField() -> TitleTextField {
        let component = TitleTextField()
        component.animationTime = 0.1
        component.backgroundColors = TextField.State<UIColor?>(UIColor.systemBackground)
        component.edgeInset = UIEdgeInsets(0)
        component.error = nil
        component.errorColor = self.theme.errorColor
        component.errorFont = UIFont.systemFont(ofSize: 12)
        component.info = nil
        component.infoColor = self.theme.textSecondaryColor
        component.infoFont = UIFont.systemFont(ofSize: 12)
        component.isEnabled = true
        component.paddingEdgeInset = UIEdgeInsets(
            vertical: 8,
            horizontal: 16
        )
        component.placeholder = nil
        component.text = nil
        component.textColors = TextField.State<UIColor?>(
            active: self.theme.textPrimaryColor,
            selected: self.theme.textPrimaryColor,
            disabled: self.theme.dividerColor,
            error: self.theme.errorColor
        )
        component.textFieldDelegate = TextFieldDelegates.default()
        component.textFonts = TextField.State<UIFont>(UIFont.systemFont(ofSize: 16))
        component.title = nil
        component.titleColors = TextField.State<UIColor?>(
            active: self.theme.textPrimaryColor,
            selected: self.theme.textPrimaryColor,
            disabled: self.theme.dividerColor,
            error: self.theme.errorColor
        )
        component.titleFonts = TextField.State<UIFont>(UIFont.systemFont(ofSize: 12))
        component.underscoreColor = self.theme.dividerColor
        return component
    }
}
