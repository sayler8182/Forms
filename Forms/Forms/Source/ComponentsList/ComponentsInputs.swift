//
//  ComponentsInputs.swift
//  Forms
//
//  Created by Konrad on 3/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

public enum ComponentsInputs: ComponentsList {
    public enum pin {
        public static func `default`() -> PinView {
            let component = PinView()
            component.animationTime = 0.1
            component.error = nil
            component.info = nil
            component.isEnabled = true
            component.itemSpacing = 6.0
            component.itemWidth = 30.0
            component.keyboardType = .numberPad
            component.marginEdgeInset = UIEdgeInsets(0)
            component.numberOfChars = 4
            component.paddingEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16)
            component.placeholder = nil
            component.text = nil
            component.textAlignment = .center
            component.title = nil
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColors = PinView.State<UIColor?>(Theme.Colors.primaryLight)
                component.errorColor = Theme.Colors.red
                component.errorFont = Theme.Fonts.regular(ofSize: 12)
                component.infoColor = Theme.Colors.gray
                component.infoFont = Theme.Fonts.regular(ofSize: 12)
                component.placeholderColors = PinView.State<UIColor?>(Theme.Colors.primaryDark.withAlphaComponent(0.3))
                component.placeholderFonts = PinView.State<UIFont>(Theme.Fonts.regular(ofSize: 32))
                component.textColors = PinView.State<UIColor?>(
                    active: Theme.Colors.primaryDark,
                    selected: Theme.Colors.primaryDark,
                    disabled: Theme.Colors.primaryDark,
                    error: Theme.Colors.red)
                component.textFonts = PinView.State<UIFont>(Theme.Fonts.regular(ofSize: 32))
                component.titleColors = PinView.State<UIColor?>(
                    active: Theme.Colors.primaryDark,
                    selected: Theme.Colors.primaryDark,
                    disabled: Theme.Colors.primaryDark,
                    error: Theme.Colors.red)
                component.titleFonts = PinView.State<UIFont>(Theme.Fonts.regular(ofSize: 12))
                component.underscoreColors = PinView.State<UIColor?>(
                    active: Theme.Colors.gray,
                    selected: Theme.Colors.primaryDark,
                    disabled: Theme.Colors.gray,
                    error: Theme.Colors.red)
            }
            return component
        }
    }
        
    public enum searchBar {
        public static func `default`() -> SearchBar {
            let component = SearchBar()
                .with(width: 320, height: 64)
            component.animationTime = 0.1
            component.isEnabled = true
            component.marginEdgeInset = UIEdgeInsets(0)
            component.paddingEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16)
            component.placeholder = nil
            component.text = nil
            component.textFieldDelegate = TextFieldDelegates.default()
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColors = SearchBar.State<UIColor?>(Theme.Colors.primaryLight)
                component.textColors = SearchBar.State<UIColor?>(
                    active: Theme.Colors.primaryDark,
                    selected: Theme.Colors.primaryDark,
                    disabled: Theme.Colors.primaryDark)
                component.textFonts = SearchBar.State<UIFont>(Theme.Fonts.regular(ofSize: 16))
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
                component.textFieldDelegate = TextFieldDelegates.format(format: "DD/DD/DDDD")
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
                component.textFieldDelegate = TextFieldDelegates.format(format: "")
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
                component.textFieldDelegate = TextFieldDelegates.format(format: "DD-DDD")
                component.maskText = "00-000"
                return component
            }
        }
        
        public static func `default`() -> TitleTextField {
            let component = TitleTextField()
            component.animationTime = 0.1
            component.error = nil
            component.info = nil
            component.isEnabled = true
            component.marginEdgeInset = UIEdgeInsets(0)
            component.maskText = nil
            component.paddingEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16)
            component.placeholder = nil
            component.text = nil
            component.textFieldDelegate = TextFieldDelegates.default()
            component.title = nil
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColors = TextField.State<UIColor?>(Theme.Colors.primaryLight)
                component.errorColor = Theme.Colors.red
                component.errorFont = Theme.Fonts.regular(ofSize: 12)
                component.infoColor = Theme.Colors.gray
                component.infoFont = Theme.Fonts.regular(ofSize: 12)
                component.maskColors = TextField.State<UIColor?>(Theme.Colors.primaryDark.withAlphaComponent(0.3))
                component.maskFonts = TextField.State<UIFont>(Theme.Fonts.regular(ofSize: 16))
                component.placeholderColors = TextField.State<UIColor?>(Theme.Colors.primaryDark.withAlphaComponent(0.3))
                component.placeholderFonts = TextField.State<UIFont>(Theme.Fonts.regular(ofSize: 16))
                component.textColors = TextField.State<UIColor?>(
                    active: Theme.Colors.primaryDark,
                    selected: Theme.Colors.primaryDark,
                    disabled: Theme.Colors.primaryDark,
                    error: Theme.Colors.red)
                component.textFonts = TextField.State<UIFont>(Theme.Fonts.regular(ofSize: 16))
                component.titleColors = TextField.State<UIColor?>(
                    active: Theme.Colors.primaryDark,
                    selected: Theme.Colors.primaryDark,
                    disabled: Theme.Colors.primaryDark,
                    error: Theme.Colors.red)
                component.titleFonts = TextField.State<UIFont>(Theme.Fonts.regular(ofSize: 12))
                component.underscoreColors = TextField.State<UIColor?>(
                    active: Theme.Colors.gray,
                    selected: Theme.Colors.primaryDark,
                    disabled: Theme.Colors.gray,
                    error: Theme.Colors.red)
            }
            return component
        }
    }
    public enum textView {
        public static func `default`() -> TitleTextView {
            let component = TitleTextView()
            component.animationTime = 0.1
            component.error = nil
            component.info = nil
            component.isEnabled = true
            component.marginEdgeInset = UIEdgeInsets(0)
            component.paddingEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16)
            component.placeholder = nil
            component.text = nil
            component.textViewDelegate = nil
            component.title = nil
            component.onSetTheme = Strong(component) { (component) in
                component.backgroundColors = TextView.State<UIColor?>(Theme.Colors.primaryLight)
                component.errorColor = Theme.Colors.red
                component.errorFont = Theme.Fonts.regular(ofSize: 12)
                component.infoColor = Theme.Colors.gray
                component.infoFont = Theme.Fonts.regular(ofSize: 12)
                component.placeholderColors = TextView.State<UIColor?>(Theme.Colors.primaryDark.withAlphaComponent(0.3))
                component.placeholderFonts = TextView.State<UIFont>(Theme.Fonts.regular(ofSize: 16))
                component.textColors = TextView.State<UIColor?>(
                    active: Theme.Colors.primaryDark,
                    selected: Theme.Colors.primaryDark,
                    disabled: Theme.Colors.primaryDark,
                    error: Theme.Colors.red)
                component.textFonts = TextView.State<UIFont>(Theme.Fonts.regular(ofSize: 16))
                component.titleColors = TextView.State<UIColor?>(
                    active: Theme.Colors.primaryDark,
                    selected: Theme.Colors.primaryDark,
                    disabled: Theme.Colors.primaryDark,
                    error: Theme.Colors.red)
                component.titleFonts = TextView.State<UIFont>(Theme.Fonts.regular(ofSize: 12))
                component.underscoreColors = TextView.State<UIColor?>(
                    active: Theme.Colors.gray,
                    selected: Theme.Colors.primaryDark,
                    disabled: Theme.Colors.gray,
                    error: Theme.Colors.red)
            }
            return component
        }
    }
}
