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
    
    public static func defaultAmountTextField() -> TitleTextField {
        let component = ComponentsInputs.defaultTextField()
        component.keyboardType = .numberPad
        component.textFieldDelegate = TextFieldDelegates.amount()
        return component
    }
    
    public static func defaultEmailTextField() -> TitleTextField {
        let component = ComponentsInputs.defaultTextField()
        component.autocapitalizationType = .none
        component.autocorrectionType = .no
        component.keyboardType = .emailAddress
        component.textFieldDelegate = TextFieldDelegates.email()
        return component
    }
    
    public static func defaultPeselTextField() -> TitleTextField {
        let component = ComponentsInputs.defaultTextField()
        component.keyboardType = .numberPad
        component.textFieldDelegate = TextFieldDelegates.pesel()
        return component
    }
    
    public static func defaultPhoneTextField() -> TitleTextField {
        let component = ComponentsInputs.defaultTextField()
        component.keyboardType = .phonePad
        component.textFieldDelegate = TextFieldDelegates.phone()
        return component
    }
    
    public static func defaultTextField() -> TitleTextField {
        let component = TitleTextField()
        component.animationTime = 0.1
        component.backgroundColors = TextField.State<UIColor?>(UIColor.systemBackground)
        component.edgeInset = UIEdgeInsets(0)
        component.error = nil
        component.errorColor = UIColor.systemRed
        component.errorFont = UIFont.systemFont(ofSize: 12)
        component.info = nil
        component.infoColor = UIColor.systemGray
        component.infoFont = UIFont.systemFont(ofSize: 12)
        component.isEnabled = true
        component.paddingEdgeInset = UIEdgeInsets(
            vertical: 8,
            horizontal: 16
        )
        component.placeholder = nil
        component.text = nil
        component.textColors = TextField.State<UIColor?>(
            active: UIColor.label,
            selected: UIColor.label,
            disabled: UIColor.label,
            error: UIColor.systemRed
        )
        component.textFieldDelegate = TextFieldDelegates.default()
        component.textFonts = TextField.State<UIFont>(UIFont.systemFont(ofSize: 16))
        component.title = nil
        component.titleColors = TextField.State<UIColor?>(
            active: UIColor.label,
            selected: UIColor.label,
            disabled: UIColor.label,
            error: UIColor.systemRed
        )
        component.titleFonts = TextField.State<UIFont>(UIFont.systemFont(ofSize: 12))
        component.underscoreColor = UIColor.systemGray
        return component
    }
}
