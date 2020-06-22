//
//  DateValidator.swift
//  FormsValidators
//
//  Created by Konrad on 5/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import Foundation

// MARK: DateValidator
public class DateValidator: FormatValidator {
    public let dateFormat: String
    
    override public var formatError: ValidationError {
        return .dateError(self.format)
    }
    
    public init(format: FormatProtocol = Format("dd/MM/yyyy", formatChars: Format.dateFormatChars, isNumber: true),
                dateFormat: String = "dd/MM/yyyy",
                isRequired: Bool = true) {
        self.dateFormat = dateFormat
        super.init(format: format, isRequired: isRequired)
    }
    
    override public func isFormatValid(_ string: String) -> Bool {
        return string.asDate(format: self.dateFormat).isNotNil
    }
}
