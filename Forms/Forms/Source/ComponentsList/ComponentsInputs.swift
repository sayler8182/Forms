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
    
    public enum searchBar {
        public static func `default`() -> SearchBar {
            let component = SearchBar()
                .with(width: 320, height: 64)
            component.animationTime = 0.1
            component.backgroundColors = SearchBar.State<UIColor?>(Theme.Colors.primaryBackground)
            component.marginEdgeInset = UIEdgeInsets(0)
            component.isEnabled = true
            component.paddingEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16
            )
            component.placeholder = nil
            component.text = nil
            component.textColors = SearchBar.State<UIColor?>(
                active: Theme.Colors.primaryText,
                selected: Theme.Colors.primaryText,
                disabled: Theme.Colors.primaryText
            )
            component.textFieldDelegate = TextFieldDelegates.default()
            component.textFonts = SearchBar.State<UIFont>(Theme.Fonts.regular(ofSize: 16))
            component.onSetTheme = { [weak component] in
                guard let component = component else { return }
                component.backgroundColors = SearchBar.State<UIColor?>(Theme.Colors.primaryBackground)
                component.textColors = SearchBar.State<UIColor?>(
                    active: Theme.Colors.primaryText,
                    selected: Theme.Colors.primaryText,
                    disabled: Theme.Colors.primaryText
                )
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
            component.backgroundColors = TextField.State<UIColor?>(Theme.Colors.primaryBackground)
            component.marginEdgeInset = UIEdgeInsets(0)
            component.error = nil
            component.errorColor = Theme.Colors.red
            component.errorFont = Theme.Fonts.regular(ofSize: 12)
            component.info = nil
            component.infoColor = Theme.Colors.gray
            component.infoFont = Theme.Fonts.regular(ofSize: 12)
            component.isEnabled = true
            component.paddingEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16
            )
            component.placeholder = nil
            component.placeholderColors = TextField.State<UIColor?>(Theme.Colors.primaryText.withAlphaComponent(0.3))
            component.placeholderFonts = TextField.State<UIFont>(Theme.Fonts.regular(ofSize: 16))
            component.text = nil
            component.textColors = TextField.State<UIColor?>(
                active: Theme.Colors.primaryText,
                selected: Theme.Colors.primaryText,
                disabled: Theme.Colors.primaryText,
                error: Theme.Colors.red
            )
            component.textFieldDelegate = TextFieldDelegates.default()
            component.textFonts = TextField.State<UIFont>(Theme.Fonts.regular(ofSize: 16))
            component.title = nil
            component.titleColors = TextField.State<UIColor?>(
                active: Theme.Colors.primaryText,
                selected: Theme.Colors.primaryText,
                disabled: Theme.Colors.primaryText,
                error: Theme.Colors.red
            )
            component.titleFonts = TextField.State<UIFont>(Theme.Fonts.regular(ofSize: 12))
            component.underscoreColors = TextField.State<UIColor?>(
                active: Theme.Colors.gray,
                selected: Theme.Colors.primaryText,
                disabled: Theme.Colors.gray,
                error: Theme.Colors.red
            )
            component.onSetTheme = { [weak component] in
                guard let component = component else { return }
                component.backgroundColors = TextField.State<UIColor?>(Theme.Colors.primaryBackground)
                component.errorColor = Theme.Colors.red
                component.errorFont = Theme.Fonts.regular(ofSize: 12)
                component.infoColor = Theme.Colors.gray
                component.infoFont = Theme.Fonts.regular(ofSize: 12)
                component.placeholderColors = TextField.State<UIColor?>(Theme.Colors.primaryText.withAlphaComponent(0.3))
                component.placeholderFonts = TextField.State<UIFont>(Theme.Fonts.regular(ofSize: 16))
                component.textColors = TextField.State<UIColor?>(
                    active: Theme.Colors.primaryText,
                    selected: Theme.Colors.primaryText,
                    disabled: Theme.Colors.primaryText,
                    error: Theme.Colors.red
                )
                component.textFonts = TextField.State<UIFont>(Theme.Fonts.regular(ofSize: 16))
                component.titleColors = TextField.State<UIColor?>(
                    active: Theme.Colors.primaryText,
                    selected: Theme.Colors.primaryText,
                    disabled: Theme.Colors.primaryText,
                    error: Theme.Colors.red
                )
                component.titleFonts = TextField.State<UIFont>(Theme.Fonts.regular(ofSize: 12))
                component.underscoreColors = TextField.State<UIColor?>(
                    active: Theme.Colors.gray,
                    selected: Theme.Colors.primaryText,
                    disabled: Theme.Colors.gray,
                    error: Theme.Colors.red
                )
            }
            return component
        }
    }
    public enum textView {
        public static func `default`() -> TitleTextView {
            let component = TitleTextView()
            component.animationTime = 0.1
            component.backgroundColors = TextView.State<UIColor?>(Theme.Colors.primaryBackground)
            component.marginEdgeInset = UIEdgeInsets(0)
            component.error = nil
            component.errorColor = Theme.Colors.red
            component.errorFont = Theme.Fonts.regular(ofSize: 12)
            component.info = nil
            component.infoColor = Theme.Colors.gray
            component.infoFont = Theme.Fonts.regular(ofSize: 12)
            component.isEnabled = true
            component.paddingEdgeInset = UIEdgeInsets(
                vertical: 8,
                horizontal: 16
            )
            component.placeholder = nil
            component.placeholderColors = TextView.State<UIColor?>(Theme.Colors.primaryText.withAlphaComponent(0.3))
            component.placeholderFonts = TextView.State<UIFont>(Theme.Fonts.regular(ofSize: 16))
            component.text = nil
            component.textColors = TextView.State<UIColor?>(
                active: Theme.Colors.primaryText,
                selected: Theme.Colors.primaryText,
                disabled: Theme.Colors.primaryText,
                error: Theme.Colors.red
            )
            component.textViewDelegate = nil
            component.textFonts = TextView.State<UIFont>(Theme.Fonts.regular(ofSize: 16))
            component.title = nil
            component.titleColors = TextView.State<UIColor?>(
                active: Theme.Colors.primaryText,
                selected: Theme.Colors.primaryText,
                disabled: Theme.Colors.primaryText,
                error: Theme.Colors.red
            )
            component.titleFonts = TextView.State<UIFont>(Theme.Fonts.regular(ofSize: 12))
            component.underscoreColors = TextView.State<UIColor?>(
                active: Theme.Colors.gray,
                selected: Theme.Colors.primaryText,
                disabled: Theme.Colors.gray,
                error: Theme.Colors.red
            )
            component.onSetTheme = { [weak component] in
                guard let component = component else { return }
                component.backgroundColors = TextView.State<UIColor?>(Theme.Colors.primaryBackground)
                component.errorColor = Theme.Colors.red
                component.errorFont = Theme.Fonts.regular(ofSize: 12)
                component.infoColor = Theme.Colors.gray
                component.infoFont = Theme.Fonts.regular(ofSize: 12)
                component.placeholderColors = TextView.State<UIColor?>(Theme.Colors.primaryText.withAlphaComponent(0.3))
                component.placeholderFonts = TextView.State<UIFont>(Theme.Fonts.regular(ofSize: 16))
                component.textColors = TextView.State<UIColor?>(
                    active: Theme.Colors.primaryText,
                    selected: Theme.Colors.primaryText,
                    disabled: Theme.Colors.primaryText,
                    error: Theme.Colors.red
                )
                component.textFonts = TextView.State<UIFont>(Theme.Fonts.regular(ofSize: 16))
                component.titleColors = TextView.State<UIColor?>(
                    active: Theme.Colors.primaryText,
                    selected: Theme.Colors.primaryText,
                    disabled: Theme.Colors.primaryText,
                    error: Theme.Colors.red
                )
                component.titleFonts = TextView.State<UIFont>(Theme.Fonts.regular(ofSize: 12))
                component.underscoreColors = TextView.State<UIColor?>(
                    active: Theme.Colors.gray,
                    selected: Theme.Colors.primaryText,
                    disabled: Theme.Colors.gray,
                    error: Theme.Colors.red
                )
            }
            return component
        }
    }
}
