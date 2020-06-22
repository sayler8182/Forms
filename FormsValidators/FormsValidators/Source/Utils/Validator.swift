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
public protocol ValidationErrorTypeProtocol {
    var rawValue: String { get }
    var error: ValidationError { get }
}
public enum ValidationErrorType: String, ValidationErrorTypeProtocol {
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
    static var unknownError = ValidationErrorType.unknown.error
    static var amountError = ValidationErrorType.amount.error
    static var emailError = ValidationErrorType.email.error
    static var notEmptyError = ValidationErrorType.notEmpty.error
    static var passwordError = ValidationErrorType.password.error
    static var peselError = ValidationErrorType.pesel.error
    static var peselShortError = ValidationErrorType.peselShort.error
    static var peselLongError = ValidationErrorType.peselLong.error
    static var phoneError = ValidationErrorType.phone.error
    static var stringError = ValidationErrorType.string.error
    
    static func amountMinError(_ minAmount: String) -> ValidationError {
        ValidationError(ValidationErrorType.amountMin, [minAmount])
    }
    static func amountMaxError(_ maxAmount: String) -> ValidationError {
        ValidationError(ValidationErrorType.amountMax, [maxAmount])
    }
    static func dateError(_ format: FormatProtocol) -> ValidationError {
        ValidationError(ValidationErrorType.date, [format.format])
    }
    static func formatError(_ format: FormatProtocol) -> ValidationError {
        ValidationError(ValidationErrorType.format, [format.format])
    }
    static func lengthError(_ length: String) -> ValidationError {
        ValidationError(ValidationErrorType.length, [length])
    }
    static func lengthMinError(_ minLength: String) -> ValidationError {
        ValidationError(ValidationErrorType.lengthMin, [minLength])
    }
    static func lengthMaxError(_ maxLength: String) -> ValidationError {
        ValidationError(ValidationErrorType.lengthMax, [maxLength])
    }
    static func postCodeError(_ format: FormatProtocol) -> ValidationError {
        ValidationError(ValidationErrorType.postCode, [format.format])
    }
    
    private let type: ValidationErrorTypeProtocol
    private let parameters: [Any]
    private lazy var translator: ValidatorTranslatorProtocol = {
        let translator: ValidatorTranslatorProtocol? = Injector.main.resolveOrDefault("FormsValidators")
        return translator ?? ValidatorTranslator()
    }()
    
    public init(_ type: ValidationErrorTypeProtocol,
                _ parameters: [Any] = []) {
        self.type = type
        self.parameters = parameters
    }
    
    public var description: String? {
        return self.translator.translate(self.type, self.parameters)
    }
}

public protocol ValidatorTranslatorProtocol {
    func translate(_ type: ValidationErrorTypeProtocol,
                   _ parameters: [Any]) -> String?
}
open class ValidatorTranslator: ValidatorTranslatorProtocol {
    public init() { }
    open func translate(_ type: ValidationErrorTypeProtocol,
                        _ parameters: [Any]) -> String? {
        switch type.rawValue {
        case ValidationErrorType.unknown.rawValue:
            return "Validator internal error"
        case ValidationErrorType.amount.rawValue:
            return "Incorrect amount format"
        case ValidationErrorType.email.rawValue:
            return "Incorrect email format"
        case ValidationErrorType.notEmpty.rawValue:
            return "This field is required"
        case ValidationErrorType.password.rawValue:
            return "Password is too weak"
        case ValidationErrorType.pesel.rawValue:
            return "Incorrect pesel format"
        case ValidationErrorType.peselShort.rawValue:
            return "Pesel number is too short"
        case ValidationErrorType.peselLong.rawValue:
            return "Pesel number is too long"
        case ValidationErrorType.phone.rawValue:
            return "Incorrect phone number format"
        case ValidationErrorType.string.rawValue:
            return "Incorrect text format"
            
        case ValidationErrorType.amountMin.rawValue:
            return "Minimum allowed amount is \(parameters[safe: 0, or: ""])"
        case ValidationErrorType.amountMax.rawValue:
            return "Maximum allowed amount is \(parameters[safe: 0, or: ""])"
        case ValidationErrorType.date.rawValue:
            return "Incorrect date format (\(parameters[safe: 0, or: ""]))"
        case ValidationErrorType.format.rawValue:
            return "Incorrect format (\(parameters[safe: 0, or: ""]))"
        case ValidationErrorType.length.rawValue:
            return "Allowed length is \(parameters[safe: 0, or: ""]) characters"
        case ValidationErrorType.lengthMin.rawValue:
            return "Minimum allowed length is \(parameters[safe: 0, or: ""]) characters"
        case ValidationErrorType.lengthMax.rawValue:
            return "Maximum allowed length is \(parameters[safe: 0, or: ""]) characters"
        case ValidationErrorType.postCode.rawValue:
            return "Incorrect post code format (\(parameters[safe: 0, or: ""]))"
            
        default:
            return nil
        }
    }
}
