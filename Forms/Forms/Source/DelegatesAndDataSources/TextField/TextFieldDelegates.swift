//
//  TextFieldDelegates.swift
//  Forms
//
//  Created by Konrad on 4/6/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

public enum TextFieldDelegates {
    public typealias amount = TextFieldAmountDelegate
    public typealias `default` = TextFieldDelegate
    public typealias email = TextFieldEmailDelegate
    public typealias format = TextFieldFormatDelegate
    public typealias pesel = TextFieldPeselDelegate
    public typealias phone = TextFieldPhoneDelegate
}
