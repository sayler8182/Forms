//
//  Validator.swift
//  FormsValidators
//
//  Created by Konrad on 3/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import FormsUtils
import Foundation

internal var alphaCharacters = "a-zA-Z\\-_ ’'‘ÆÐƎƏƐƔĲŊŒẞÞǷȜæðǝəɛɣĳŋœĸſßþƿȝĄƁÇĐƊĘĦĮƘŁØƠŞȘŢȚŦŲƯY̨Ƴąɓçđɗęħįƙłøơşșţțŧųưy̨ƴÁÀÂÄǍĂĀÃÅǺĄÆǼǢƁĆĊĈČÇĎḌĐƊÐÉÈĖÊËĚĔĒĘẸƎƏƐĠĜǦĞĢƔáàâäǎăāãåǻąæǽǣɓćċĉčçďḍđɗðéèėêëěĕēęẹǝəɛġĝǧğģɣĤḤĦIÍÌİÎÏǏĬĪĨĮỊĲĴĶƘĹĻŁĽĿʼNŃN̈ŇÑŅŊÓÒÔÖǑŎŌÕŐỌØǾƠŒĥḥħıíìiîïǐĭīĩįịĳĵķƙĸĺļłľŀŉńn̈ňñņŋóòôöǒŏōõőọøǿơœŔŘŖŚŜŠŞȘṢẞŤŢṬŦÞÚÙÛÜǓŬŪŨŰŮŲỤƯẂẀŴẄǷÝỲŶŸȲỸƳŹŻŽẒŕřŗſśŝšşșṣßťţṭŧþúùûüǔŭūũűůųụưẃẁŵẅƿýỳŷÿȳỹƴźżžẓ"

// MARK: Validator
open class Validator: Equatable {
    public var dependencies: [Validator] = []
    public let isRequired: Bool
    
    public init(isRequired: Bool = true) {
        self.isRequired = isRequired
    }
    
    open func validate(_ value: Any?) -> ValidationResult {
        return ValidationResult()
    }
    
    open func shouldValidate(_ value: Any?) -> Bool {
        let value: String = value as? String ?? ""
        return self.isRequired || value.isNotEmpty
    }
    
    open func validateDependencies(_ value: Any?) -> ValidationResult? {
        for validator in self.dependencies {
            let result: ValidationResult = validator.validate(value)
            guard result.isValid else { return result }
        }
        return nil
    }
    
    public static func == (lhs: Validator, rhs: Validator) -> Bool {
        return lhs === rhs
    }
}

// MARK: Validable
public protocol Validable: class {
    typealias OnValidate = ((Bool) -> Void)
    
    var validators: [Validator] { get set }
    var validatorTriggered: Bool { get set }
    var onValidate: OnValidate? { get set }
    
    func validatorTrigger()
    @discardableResult
    func validate() -> Bool
    @discardableResult
    func validate(_ isSilence: Bool) -> Bool
    @discardableResult
    func validate(_ validator: Validator,
                  _ isSilence: Bool) -> Bool
    func addValidator(_ validator: Validator)
    func removeValidator(_ validator: Validator)
}

public extension Validable {
    func validatorTrigger() {
        self.validatorTriggered = true
    }
    
    @discardableResult
    func validate() -> Bool {
        return self.validate(false)
    }
    
    @discardableResult
    func validate(_ isSilence: Bool) -> Bool {
        var result: Bool = true
        for validator in self.validators {
            result = result && self.validate(validator, isSilence)
        }
        if !isSilence {
            self.onValidate?(result)
        }
        return result
    }
    
    func addValidator(_ validator: Validator) {
        self.validators.append(validator)
    }
    
    func removeValidator(_ validator: Validator) {
        guard let index: Int = self.validators.firstIndex(of: validator) else { return }
        self.validators.remove(at: index)
    }
}

// MARK: ValidatorResult
public struct ValidationResult {
    public var isValid: Bool
    public var error: ValidationError?
    
    public init() {
        self.isValid = true
        self.error = nil
    }
    
    public init(error: ValidationError) {
        self.isValid = false
        self.error = error
    }
    
    public var description: String? {
        return self.error?.description
    }
}

// MARK: ValidationError
public protocol FormsValidationErrorTypeProtocol {
    var rawValue: String { get }
    var error: ValidationError { get }
}
public enum FormsValidationErrorType: String, FormsValidationErrorTypeProtocol {
    case unknown
    case amount
    case amountMin
    case amountMax
    case date
    case format
    case email
    case length
    case lengthMin
    case lengthMax
    case notEmpty
    case password
    case pesel
    case peselShort
    case peselLong
    case phone
    case postCode
    case string
    
    public var error: ValidationError {
        return ValidationError(self)
    }
}

public class ValidationError {
    static var unknownError = FormsValidationErrorType.unknown.error
    static var amountError = FormsValidationErrorType.amount.error
    static var emailError = FormsValidationErrorType.email.error
    static var notEmptyError = FormsValidationErrorType.notEmpty.error
    static var passwordError = FormsValidationErrorType.password.error
    static var peselError = FormsValidationErrorType.pesel.error
    static var peselShortError = FormsValidationErrorType.peselShort.error
    static var peselLongError = FormsValidationErrorType.peselLong.error
    static var phoneError = FormsValidationErrorType.phone.error
    static var stringError = FormsValidationErrorType.string.error
    
    static func amountMinError(_ minAmount: String) -> ValidationError {
        ValidationError(FormsValidationErrorType.amountMin, [minAmount])
    }
    static func amountMaxError(_ maxAmount: String) -> ValidationError {
        ValidationError(FormsValidationErrorType.amountMax, [maxAmount])
    }
    static func dateError(_ format: FormatProtocol) -> ValidationError {
        ValidationError(FormsValidationErrorType.date, [format.format])
    }
    static func formatError(_ format: FormatProtocol) -> ValidationError {
        ValidationError(FormsValidationErrorType.format, [format.format])
    }
    static func lengthError(_ length: String) -> ValidationError {
        ValidationError(FormsValidationErrorType.length, [length])
    }
    static func lengthMinError(_ minLength: String) -> ValidationError {
        ValidationError(FormsValidationErrorType.lengthMin, [minLength])
    }
    static func lengthMaxError(_ maxLength: String) -> ValidationError {
        ValidationError(FormsValidationErrorType.lengthMax, [maxLength])
    }
    static func postCodeError(_ format: FormatProtocol) -> ValidationError {
        ValidationError(FormsValidationErrorType.postCode, [format.format])
    }
    
    private let type: FormsValidationErrorTypeProtocol
    private let parameters: [Any]
    private lazy var translator: FormsValidatorTranslatorProtocol = {
        let translator: FormsValidatorTranslatorProtocol? = Injector.main.resolveOrDefault("FormsValidators")
        return translator ?? FormsValidatorTranslator()
    }()
    
    public init(_ type: FormsValidationErrorTypeProtocol,
                _ parameters: [Any] = []) {
        self.type = type
        self.parameters = parameters
    }
    
    public var description: String? {
        return self.translator.translate(self.type, self.parameters)
    }
}

public protocol FormsValidatorTranslatorProtocol {
    func translate(_ type: FormsValidationErrorTypeProtocol,
                   _ parameters: [Any]) -> String?
}
open class FormsValidatorTranslator: FormsValidatorTranslatorProtocol {
    public init() { }
    open func translate(_ type: FormsValidationErrorTypeProtocol,
                        _ parameters: [Any]) -> String? {
        switch type.rawValue {
        case FormsValidationErrorType.unknown.rawValue:
            return "Validator internal error"
        case FormsValidationErrorType.amount.rawValue:
            return "Incorrect amount format"
        case FormsValidationErrorType.email.rawValue:
            return "Incorrect email format"
        case FormsValidationErrorType.notEmpty.rawValue:
            return "This field is required"
        case FormsValidationErrorType.password.rawValue:
            return "Password is too weak"
        case FormsValidationErrorType.pesel.rawValue:
            return "Incorrect pesel format"
        case FormsValidationErrorType.peselShort.rawValue:
            return "Pesel number is too short"
        case FormsValidationErrorType.peselLong.rawValue:
            return "Pesel number is too long"
        case FormsValidationErrorType.phone.rawValue:
            return "Incorrect phone number format"
        case FormsValidationErrorType.string.rawValue:
            return "Incorrect text format"
            
        case FormsValidationErrorType.amountMin.rawValue:
            return "Minimum allowed amount is \(parameters[safe: 0, or: ""])"
        case FormsValidationErrorType.amountMax.rawValue:
            return "Maximum allowed amount is \(parameters[safe: 0, or: ""])"
        case FormsValidationErrorType.date.rawValue:
            return "Incorrect date format (\(parameters[safe: 0, or: ""]))"
        case FormsValidationErrorType.format.rawValue:
            return "Incorrect format (\(parameters[safe: 0, or: ""]))"
        case FormsValidationErrorType.length.rawValue:
            return "Allowed length is \(parameters[safe: 0, or: ""]) characters"
        case FormsValidationErrorType.lengthMin.rawValue:
            return "Minimum allowed length is \(parameters[safe: 0, or: ""]) characters"
        case FormsValidationErrorType.lengthMax.rawValue:
            return "Maximum allowed length is \(parameters[safe: 0, or: ""]) characters"
        case FormsValidationErrorType.postCode.rawValue:
            return "Incorrect post code format (\(parameters[safe: 0, or: ""]))"
            
        default:
            return nil
        }
    }
}
