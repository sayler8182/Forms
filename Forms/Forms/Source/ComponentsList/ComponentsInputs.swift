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
    
    public enum textField {
        public enum amount {
            public static func `default`() -> TitleTextField {
                let component = ComponentsInputs.textField.default()
                component.keyboardType = .numberPad
                component.textFieldDelegate = TextFieldDelegates.amount()
                return component
            }
        }
        
        public enum email {
            public static func `default`() -> TitleTextField {
                let component = ComponentsInputs.textField.default()
                component.autocapitalizationType = .none
                component.autocorrectionType = .no
                component.keyboardType = .emailAddress
                component.textFieldDelegate = TextFieldDelegates.email()
                return component
            }
        }
        
        public enum pesel {
            public static func `default`() -> TitleTextField {
                let component = ComponentsInputs.textField.default()
                component.keyboardType = .numberPad
                component.textFieldDelegate = TextFieldDelegates.pesel()
                return component
            }
        }
        
        public enum phone {
            public static func `default`() -> TitleTextField {
                let component = ComponentsInputs.textField.default()
                component.keyboardType = .phonePad
                component.textFieldDelegate = TextFieldDelegates.phone()
                return component
            }
        }
        
        public enum postCode {
            public static func `default`() -> TitleTextField {
                let component = ComponentsInputs.textField.default()
                component.keyboardType = .numberPad
                component.textFieldDelegate = TextFieldDelegates.postCode()
                return component
            }
        }
        
        public static func `default`() -> TitleTextField {
            let component = TitleTextField()
            component.animationTime = 0.1
            component.backgroundColors = TextField.State<UIColor?>(Theme.systemBackground)
            component.marginEdgeInset = UIEdgeInsets(0)
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
                active: Theme.label,
                selected: Theme.label,
                disabled: Theme.label,
                error: Theme.systemRed
            )
            component.textFieldDelegate = TextFieldDelegates.default()
            component.textFonts = TextField.State<UIFont>(UIFont.systemFont(ofSize: 16))
            component.title = nil
            component.titleColors = TextField.State<UIColor?>(
                active: Theme.label,
                selected: Theme.label,
                disabled: Theme.label,
                error: Theme.systemRed
            )
            component.titleFonts = TextField.State<UIFont>(UIFont.systemFont(ofSize: 12))
            component.underscoreColor = UIColor.systemGray
            return component
        }
    }
    
    public enum searchBar {
        public static func `default`() -> SearchBar {
            let component = SearchBar()
                .with(width: 320, height: 64)
            component.animationTime = 0.1
            component.backgroundColors = SearchBar.State<UIColor?>(Theme.systemBackground)
            component.marginEdgeInset = UIEdgeInsets(0)
            component.isEnabled = true
            component.paddingEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16
            )
            component.placeholder = nil
            component.text = nil
            component.textColors = SearchBar.State<UIColor?>(
                active: Theme.label,
                selected: Theme.label,
                disabled: Theme.label
            )
            component.textFieldDelegate = TextFieldDelegates.default()
            component.textFonts = SearchBar.State<UIFont>(UIFont.systemFont(ofSize: 16))
            return component
        }
    }
}
