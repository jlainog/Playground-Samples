







//: [Previous](@previous)
import Foundation
//: [state_and_data_flow](https://developer.apple.com/documentation/swiftui/state_and_data_flow)

//: [binding](https://developer.apple.com/documentation/swiftui/binding)

@propertyWrapper
struct BBinding<Value> {
    private let getter: () -> Value
    private let setter: (Value) -> Void
    
    var projectedValue: Self { self }
    
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
    static var myValue: Int
}

TestBinding.myValue = 10
TestBinding._intValue
TestBinding.myValue = 5
TestBinding.myValue
TestBinding._intValue
TestBinding.$myValue.wrappedValue
/// $ is used to access the value property in a propertyWrapper -> For this to happen implement projectedValue

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
    static var myPerson: Person
}

let nameBinding = TestBindingConvertible.$myPerson.name

nameBinding.wrappedValue = "andres"
TestBindingConvertible.myPerson.name

/*:
 [state](https://developer.apple.com/documentation/swiftui/state)
 
 [how does state mutate](https://forums.swift.org/t/why-i-can-mutate-state-var-how-does-state-property-wrapper-work-inside/27209/2)
*/
@propertyWrapper
struct SState<Value> {
    private let storage = UnsafeMutablePointer<Value>.allocate(capacity: 1)
    
    var wrappedValue: Value {
        get { storage.pointee }
        nonmutating set { storage.pointee = newValue }
    }
    var projectedValue: Self { self }
    
    init(wrappedValue value: Value) {
        storage.initialize(to: value)
    }
}
extension SState: BBindingConvertible {
    var binding: BBinding<Value> {
        .init(getter: { self.wrappedValue },
              setter: { self.wrappedValue = $0 })
    }
}

struct TestState {
    @SState
    static var person: Person = Person(name: "jaime", lastName: "laino")
}

TestState.person.lastName

let lastNameBinding = TestState.$person.lastName
lastNameBinding.wrappedValue = "Guerra"
TestState.person.lastName

//: [Next](@next)
