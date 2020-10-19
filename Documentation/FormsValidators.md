# FormsValidators

FormsValidators is a collection of validators

## Import

```swift
import FormsValidators
```

## Dependencies

```
FormsInjector.framework
FormsUtils.framework
```

## Usage

### Validators

```swift
AmountValidator(
    minAmount: 100, 
    maxAmount: 20_000, 
    currency: "$")
EmailValidator()
LengthValidator(
    minLength: 1, 
    maxLength: 20)
NotEmptyValidator()
PasswordValidator()
PeselValidator()
PhoneValidator(isRequired: false)
PostCodeValidator(format: "XX-XXX")
StringValidator()
```

### Validation

```swift
let validator = EmailValidator()
let result = validator.validate("some@email.com")
print(result.isValid, result.error)
```

### Custom ValidationError translations

```swift 
enum ValidationErrorType: String, FormsValidationErrorTypeProtocol {
    case myCustom
    
    var error: ValidationError {
        return ValidationError(self)
    }
}

extension FormsValidationError {
    static var myCustomError = AppValidationErrorType.myCustom.error
}

class ValidatorTranslator: FormsValidatorTranslator {
    override func translate(_ type: FormsValidationErrorTypeProtocol,
                            _ parameters: [Any]) -> String? {
        switch type.rawValue {
        case ValidationErrorType.myCustom.rawValue:
            return "My custom error"
        case FormsValidationErrorType.email.rawValue:
            return "My custom Incorrect email format error"
        default:
            return super.translate(type, parameters)
        }
    }
}

injector.register(FormsValidatorTranslatorProtocol.self) { _ in
    ValidatorTranslator()
}
```