//
//  PostCodeValidator.swift
//  FormsValidators
//
//  Created by Konrad on 5/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: PostCodeValidator
public class PostCodeValidator: FormatValidator {
    override public var formatError: ValidationError {
        return .postCodeError(self.format)
    }
    
    override public init(format: FormatProtocol = Format("DD-DDD"),
                         isRequired: Bool = true) {
        super.init(format: format, isRequired: isRequired)
    }
}
