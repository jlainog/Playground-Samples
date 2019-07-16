//: [Previous](@previous)

/*:
 # Key Path Member Lookup
 Proposal: [SE-0252](https://github.com/apple/swift-evolution/blob/master/proposals/0252-keypath-dynamic-member-lookup.md)
 */

import Foundation

struct Point: Equatable {
    var x, y: Double
    static let zero: Point = .init(x: 0, y: 0)
}

struct Rectangle {
    var topLeft, bottomRight: Point
}

@dynamicMemberLookup
struct Box<T> {
    var value: T
    
    subscript<U>(dynamicMember keyPath: WritableKeyPath<T, U>) -> U {
        value[keyPath: keyPath]
    }
}

var rect = Rectangle(topLeft: .zero, bottomRight: .zero)
var box = Box(value: rect)
box.topLeft
box[dynamicMember: \.topLeft]
box.value.topLeft
assert(box.topLeft == box.value.topLeft)

/*:
 # Introduce User-defined "Dynamic Member Lookup" Types
 Proposal: [SE-0195](https://github.com/apple/swift-evolution/blob/master/proposals/0195-dynamic-member-lookup.md)
 ## Implemented (Swift 4.2)
 */

import Foundation

@dynamicMemberLookup
enum JSON {
    case IntValue(Int)
    case StringValue(String)
    case ArrayValue(Array<JSON>)
    case DictionaryValue(Dictionary<String, JSON>)
    
    subscript(dynamicMember member: String) -> JSON? {
        if case .DictionaryValue(let dict) = self {
            return dict[member]
        }
        return nil
    }
}

let dict: Dictionary<String, JSON> =
    ["keyOne": .StringValue("value"),
     "keyTwo": .IntValue(123),
     "dict": .DictionaryValue(["innerKey":
        .DictionaryValue(["stringKey": .StringValue("innerValue")])])]
let json = JSON.DictionaryValue(dict)

json.keyOne
json.dict?.innerKey?.stringKey
json[dynamicMember: "keyOne"]
//: [Next](@next)
