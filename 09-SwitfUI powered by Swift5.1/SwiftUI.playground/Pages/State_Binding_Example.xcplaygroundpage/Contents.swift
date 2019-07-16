







//: [Previous](@previous)
import Foundation
//: [state_and_data_flow](https://developer.apple.com/documentation/swiftui/state_and_data_flow)

//: [binding](https://developer.apple.com/documentation/swiftui/binding)

@propertyWrapper
struct BBinding<Value> {
    private let getter: () -> Value
    private let setter: (Value) -> Void
    
    var wrappedValue: Value {
        get { getter() }
        nonmutating set { setter(newValue) }
    }
    
    init(getter: @escaping () -> Value,
         setter: @escaping (Value) -> Void) {
        self.getter = getter
        self.setter = setter
    }
}

struct TestBinding {
    static var _intValue = 0
    
    @BBinding(getter: { _intValue },
              setter: { _intValue = $0 })
    static var intValue: Int
}

TestBinding.intValue = 10
TestBinding._intValue
TestBinding.intValue = 5
TestBinding.intValue
TestBinding._intValue
TestBinding.$intValue.wrappedValue
/// $ is used to access the value property in a propertyWrapper

//: [bindingconvertible](https://developer.apple.com/documentation/swiftui/bindingconvertible)
@dynamicMemberLookup
protocol BBindingConvertible {
    associatedtype Value
    
    var binding: BBinding<Self.Value> { get }
}
extension BBindingConvertible {
    subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Self.Value, Subject>)
        -> BBinding<Subject> {
            return BBinding(
                getter: { self.binding.wrappedValue[keyPath: keyPath] },
                setter: { self.binding.wrappedValue[keyPath: keyPath] = $0 }
            )
    }
}

extension BBinding: BBindingConvertible {
    var binding: BBinding<Value> { self }
}

struct Person {
    var name: String
    var lastName: String
}

struct TestBindingConvertible {
    static var _person = Person(name: "jaime", lastName: "laino")
    
    @BBinding(getter: { _person },
              setter: { _person = $0 })
    static var person: Person
}

let nameBinding = TestBindingConvertible.$person.name

nameBinding.wrappedValue = "andres"
TestBindingConvertible.person.name

//: [state](https://developer.apple.com/documentation/swiftui/state)
@propertyWrapper
struct SState<Value> {
    var wrappedValue: Value
    
    init(initialValue value: Value) {
        self.wrappedValue = value
    }
}
extension SState: BBindingConvertible {
    var binding: BBinding<Value> = .init(getter: { wrappedValue },
                                         setter: { wrappedValue = $0 })
}

struct TestState {
    @SState
    static var person: Person = Person(name: "jaime", lastName: "laino")
}

TestState.person.lastName

let lastNameBinding = TestState.$person.lastName
lastNameBinding.value = "Guerra"
TestState.person.lastName

//: [Next](@next)
