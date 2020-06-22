//
//  ComponentsInputs.swift
//  Forms
//
//  Created by Konrad on 3/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import FormsValidators
import UIKit

public enum ComponentsInputs: ComponentsList {
    public enum pin {
        public static func `default`() -> PinView {
            let component = PinView()
            component.itemSpacing = 6.0
            component.itemWidth = 30.0
            component.keyboardType = .numberPad
            component.marginEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16)
            component.numberOfChars = 4
            component.textAlignment = .center
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColors = .init(Theme.Colors.primaryLight)
                component.errorColor = Theme.Colors.red
                component.errorFont = Theme.Fonts.regular(ofSize: 12)
                component.infoColor = Theme.Colors.gray
                component.infoFont = Theme.Fonts.regular(ofSize: 12)
                component.placeholderColors = .init(Theme.Colors.primaryDark.with(alpha: 0.3))
                component.placeholderFonts = .init(Theme.Fonts.regular(ofSize: 32))
                component.textColors = PinView.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(error: Theme.Colors.red)
                component.textFonts = .init(Theme.Fonts.regular(ofSize: 32))
                component.titleColors = PinView.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(error: Theme.Colors.red)
                component.titleFonts = .init(Theme.Fonts.regular(ofSize: 12))
                component.underscoreColors = PinView.State<UIColor?>(Theme.Colors.gray)
                    .with(selected: Theme.Colors.primaryDark)
                    .with(error: Theme.Colors.red)
            }
            return component
        }
    }
        
    public enum searchBar {
        public static func `default`() -> SearchBar {
            let component = SearchBar()
                .with(width: 320, height: 64)
            component.marginEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16)
            component.textFieldDelegate = TextFieldDelegates.default()
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColors = .init(Theme.Colors.primaryLight)
                component.textColors = .init(Theme.Colors.primaryDark)
                component.textFonts = .init(Theme.Fonts.regular(ofSize: 16))
            }
            return component
        }
    }
    
    public enum textField {
        public enum amount {
            public static func `default`() -> TitleTextField {
                let component = ComponentsInputs.textField.default()
                component.keyboardType = .numberPad
                component.textFieldDelegate = TextFieldDelegates.amount()
                return component
            }
        }
        
        public enum date {
            public static func `default`() -> TitleTextField {
                let component = ComponentsInputs.textField.default()
                component.keyboardType = .numberPad
                component.textFieldDelegate = TextFieldDelegates.format(format: "dd/MM/yyyy", formatChars: Format.dateFormatChars)
                component.maskText = "dd/MM/yyyy"
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
        
        public enum format {
            public static func `default`() -> TitleTextField {
                let component = ComponentsInputs.textField.default()
                component.textFieldDelegate = TextFieldDelegates.format(format: "", formatChars: Format.defaultFormatChars)
                return component
            }
        }
        
        public enum password {
            public static func `default`() -> TitleTextField {
                let component = ComponentsInputs.textField.default()
                component.keyboardType = .default
                component.isSecureTextEntry = true
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
                component.textFieldDelegate = TextFieldDelegates.format(format: "XX-XXX", formatChars: Format.defaultFormatChars)
                component.maskText = "00-000"
                return component
            }
        }
        
        public static func `default`() -> TitleTextField {
            let component = TitleTextField()
            component.marginEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16)
            component.textFieldDelegate = TextFieldDelegates.default()
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColors = .init(Theme.Colors.primaryLight)
                component.errorColor = Theme.Colors.red
                component.errorFont = Theme.Fonts.regular(ofSize: 12)
                component.infoColor = Theme.Colors.gray
                component.infoFont = Theme.Fonts.regular(ofSize: 12)
                component.maskColors = .init(Theme.Colors.primaryDark.with(alpha: 0.3))
                component.maskFonts = .init(Theme.Fonts.regular(ofSize: 16))
                component.placeholderColors = .init(Theme.Colors.primaryDark.with(alpha: 0.3))
                component.placeholderFonts = .init(Theme.Fonts.regular(ofSize: 16))
                component.textColors = TextField.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(error: Theme.Colors.red)
                component.textFonts = .init(Theme.Fonts.regular(ofSize: 16))
                component.titleColors = TextField.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(error: Theme.Colors.red)
                component.titleFonts = .init(Theme.Fonts.regular(ofSize: 12))
                component.underscoreColors = TextField.State<UIColor?>(Theme.Colors.gray)
                    .with(selected: Theme.Colors.primaryDark)
                    .with(error: Theme.Colors.red)
            }
            return component
        }
    }
    public enum textView {
        public static func `default`() -> TitleTextView {
            let component = TitleTextView()
            component.marginEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16)
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColors = .init(Theme.Colors.primaryLight)
                component.errorColor = Theme.Colors.red
                component.errorFont = Theme.Fonts.regular(ofSize: 12)
                component.infoColor = Theme.Colors.gray
                component.infoFont = Theme.Fonts.regular(ofSize: 12)
                component.placeholderColors = .init(Theme.Colors.primaryDark.with(alpha: 0.3))
                component.placeholderFonts = .init(Theme.Fonts.regular(ofSize: 16))
                component.textColors = TextView.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(error: Theme.Colors.red)
                component.textFonts = .init(Theme.Fonts.regular(ofSize: 16))
                component.titleColors = TextView.State<UIColor?>(Theme.Colors.primaryDark)
                    .with(error: Theme.Colors.red)
                component.titleFonts = .init(Theme.Fonts.regular(ofSize: 12))
                component.underscoreColors = TextView.State<UIColor?>(Theme.Colors.gray)
                    .with(selected: Theme.Colors.primaryDark)
                    .with(error: Theme.Colors.red)
            }
            return component
        }
    }
}
