# FormsMock

FormsMock helper 

## Import

```swift
import FormsMock
```

## Usage

### Mockable

Object must conform *Mockable* protocol.

```swift
struct User: Mockable {
    let name: String
    let email: String

    init(_ mock: Mock) {
        self.name = mock.name()
        self.email = mock.email([.nullable(chance:0.5)])
    }
}
```

Mock

```swift
let user = User.mock()
```

### Available mocks

```swift
func array<T>(of factory: @autoclosure () -> T, count: Int, options: [MockOptions] = [.none]) -> [T]!
func bool(chance: Double = 0.5, options: [MockOptions] = [.none]) -> Bool!
func date(from fromDate: String, fromFormat fromDateFormat: String = "yyyy-MM-dd", to toDate: String, toFormat toDateFormat: String = "yyyy-MM-dd", options: [MockOptions] = [.none]) -> Date!
func date(from fromDate: Date, to toDate: Date, options: [MockOptions] = [.none]) -> Date!
func email(_ options: [MockOptions] = [.none]) -> String!
func email(name: String?, lastName: String?, options: [MockOptions] = [.none]) -> String!
func item<T>(from items: [T], options: [MockOptions] = [.none]) -> T!
func lastName(_ options: [MockOptions] = [.none]) -> String!
func name(_ options: [MockOptions] = [.none]) -> String!
func number(_ range: ClosedRange<Int>, _ options: [MockOptions] = [.none]) -> Int!
func number(_ range: Range<Int>, _ options: [MockOptions] = [.none]) -> Int!
func number(_ range: ClosedRange<Double>, _ options: [MockOptions] = [.none]) -> Double!
func number(_ range: Range<Double>, _ options: [MockOptions] = [.none]) -> Double!
func password(_ options: [MockOptions] = [.none]) -> String!
func phone(prefix: String? = nil, length: Int = 9, groupingSeparator: String? = " ", options: [MockOptions] = [.none]) -> String!
func postCode(format: String = "XX-XXX", options: [MockOptions] = [.none]) -> String!
func string(_ options: [MockOptions] = [.none]) -> String!
func imageURL(_ options: [MockOptions] = [.none]) -> URL!
func uuid(_ options: [MockOptions] = [.none]) -> String!
```

### MockOptions

All methods sets mock options to .none by default and also implements nullable with chance. 

```swift
enum MockOptions {
    case none
    case length(_ length: Length)
    // chance (0...1) to set property to nil
    case nullable(_ chance: Double)
}
```