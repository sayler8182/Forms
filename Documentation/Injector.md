# Injector

Injector is a Dependency Injection microservice based on [Swinject](https://github.com/Swinject/Swinject).

## Import

```swift
import Injector
```

or 

```swift
import Forms
```

## Usage

Definition

```Swift
protocol Animal {
    var name: String { get }
}
struct Cat: Animal {
    let name: String
}
protocol Person {
    func play()
}
struct PetOwner: Person {
    let pet: Animal

    func play() {
        print("I'm playing with \(pet.name).")
    }
}
```

Registration

```Swift
let injector = Injector()
injector.register(Animal.self) { _ in 
    Cat(name: "Mimi") 
}
injector.register(Person.self) { r in
    PetOwner(pet: r.resolve(Animal.self))
}
```

Resolve

```Swift
let person = container.resolve(Person.self)
person?.play() // prints "I'm playing with Mimi."
```

or

```Swift
let person: Person = container.resolve()
person.play() // prints "I'm playing with Mimi."
```

## Scope

```Swift
injector.register(Animal.self) { _ in 
    Cat(name: "Mimi") 
}.inScope(InjectorScope.container)
```

Available scopes
```Swift
static let transient = InjectorScope(
    storageFactory: TransientStorage.init,
    description: "transient")

static let graph = InjectorScope(
    storageFactory: GraphStorage.init,
    description: "graph")

static let container = InjectorScope(
    storageFactory: PermanentStorage.init,
    description: "container")

static let weak = InjectorScope(
    storageFactory: WeakStorage.init,
    parent: InjectorScope.graph,
    description: "weak")
```