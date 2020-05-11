//
//  TextFieldDelegates.swift
//  Forms
//
//  Created by Konrad on 4/6/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

public struct TextFieldDelegates {
    private init() { }
    
    typealias amount = TextFieldAmountDelegate
    typealias `default` = TextFieldDelegate
    typealias email = TextFieldEmailDelegate
    typealias pesel = TextFieldPeselDelegate
    typealias phone = TextFieldPhoneDelegate
    typealias postCode = TextFieldPostCodeDelegate
}
