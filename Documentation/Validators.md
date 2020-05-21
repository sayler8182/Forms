# Validators

Validators is a collection of validators

## Import

```swift
import Validators
```

## Dependencies

```
Injector.framework
Utils.framework
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
PeselValidator()
PhoneValidator(isRequired: false)
PostCodeValidator(format: "XX-XXX")
```

### Validation

```swift
let validator = EmailValidator()
let result = validator.validate("some@email.com")
print(result.isValid, result.error)
```

### Custom ValidationError translations

```swift 
enum AppValidationErrorType: String, ValidationErrorTypeProtocol {
    case myCustom
    
    var error: ValidationError {
        return ValidationError(self)
    }
}

extension ValidationError {
    static var myCustomError = AppValidationErrorType.myCustom.error
}

class AppValidatorTranslator: ValidatorTranslator {
    override func translate(_ type: ValidationErrorTypeProtocol,
                            _ parameters: [Any]) -> String? {
        switch type.rawValue {
        case AppValidationErrorType.myCustom.rawValue:
            return "My custom error"
        case ValidationErrorType.email.rawValue:
            return "My custom Incorrect email format error"
        default:
            return super.translate(type, parameters)
        }
    }
}

injector.register(ValidatorTranslatorProtocol.self) { _ in
    AppValidatorTranslator()
}
```