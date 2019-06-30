







//: [Previous](@previous)
import Foundation
//: [state_and_data_flow](https://developer.apple.com/documentation/swiftui/state_and_data_flow)

//: [binding](https://developer.apple.com/documentation/swiftui/binding)

@propertyWrapper
struct BBinding<Value> {
    private let getter: () -> Value
    private let setter: (Value) -> Void
    
    var value: Value {
        get { getter() }
        nonmutating set { setter(newValue) }
    }
    
    init(getter: @escaping () -> Value,
         setter: @escaping (Value) -> Void) {
        self.getter = getter
        self.setter = setter
    }
}

struct Test1 {
    static var _intValue = 0
    
    @BBinding(getter: { _intValue },
              setter: { _intValue = $0 })
    static var intValue: Int
}

Test1.intValue = 10
Test1._intValue
Test1.intValue = 5
Test1.intValue
Test1._intValue
Test1.$intValue.value
/// $ is used to access the value property in a propertyWrapper

//: [bindingconvertible](https://developer.apple.com/documentation/swiftui/bindingconvertible)
@dynamicMemberLookup protocol BBindingConvertible {
    associatedtype Value
    
    var binding: BBinding<Self.Value> { get }
    
    subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>)
        -> BBinding<Subject> { get }
}
extension BBindingConvertible {
    subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Self.Value, Subject>)
        -> BBinding<Subject> {
            return BBinding(
                getter: { self.binding.value[keyPath: keyPath] },
                setter: { self.binding.value[keyPath: keyPath] = $0 }
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

struct Test2 {
    static private var _person = Person(name: "jaime", lastName: "laino")
    
    @BBinding(getter: { _person },
              setter: { _person = $0 })
    static var person: Person
}

let nameBinding = Test2.$person.name

nameBinding.value = "andres"
Test2.person.name

//: [state](https://developer.apple.com/documentation/swiftui/state)
@propertyWrapper
struct SState<Value>: BBindingConvertible {
    var value: Value
    var binding: BBinding<Value> = .init(getter: { value },
                                         setter: { value = $0 })
    
    init(initialValue value: Value) {
        self.value = value
    }
}

struct Test3 {
    @SState
    static var person: Person = Person(name: "jaime", lastName: "laino")
}

Test3.person.name

let lastNameBinding = Test3.$person.lastName
lastNameBinding.value = "Guerra"

//: [Next](@next)
