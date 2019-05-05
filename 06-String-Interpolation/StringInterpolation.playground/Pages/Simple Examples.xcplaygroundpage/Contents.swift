//: [Previous](@previous)
import Foundation

"the result of the Sum is \(2 + 4)"

extension String.StringInterpolation {
    mutating func appendInterpolation(sum value: Int) {
        appendLiteral("the result of the Sum is \(value)")
    }
}

"\(sum: 2+4)"


//: Lets say you want to return your github user url
//: https://github.com/jlainog

struct GitHub {
    let user: String
}

let account = GitHub(user: "jlainog")

"https://github.com/\(account.user)"

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: GitHub) {
        let literal = "[\(value.user)] (https://github.com/\(value.user))"
        
        appendLiteral(literal)
    }
}

"\(account)"

extension String.StringInterpolation {
    mutating func appendInterpolation(url value: GitHub) {
        let literal = "https://github.com/\(value.user)"
        
        appendLiteral(literal)
    }
}

"\(url: account)"

//: Lets say you want to do some number formatting
"i am thirty"
//: but using numbers
struct Person {
    let age: Int
}
/*:
```"i am \(age: Person(age: 30))" -> "i am thirty"```
 
 or
 
```"i am \(30)"                   -> "i am thirty"```
*/
extension String.StringInterpolation {
    mutating func appendInterpolation(age value: Person) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        let literal = formatter.string(from: NSNumber(value: value.age))!
        
        appendLiteral(literal)
    }

    mutating func appendInterpolation(format value: Int,
                                      using style: NumberFormatter.Style) {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        
        if let result = formatter.string(from: value as NSNumber) {
            appendLiteral(result)
        }
    }
}

"i am \(age: Person(age: 30))"
// or
"i am \(format:30, using: .spellOut)"

//: What about arrays
extension String.StringInterpolation {
    mutating func appendInterpolation(_ values: [Int]) {

        let literal = values
            .compactMap { String(describing: $0) }
            .joined(separator: ",")
        
        appendLiteral(literal)
    }
    
    mutating func appendInterpolation(_ values: [String],
                                      empty defaultValue: @autoclosure () -> String) {
        if values.count == 0 {
            appendLiteral(defaultValue())
        } else {
            appendLiteral(values.joined(separator: ", "))
        }
    }
}

"\([1,2,3,4,5])"
"\([], empty: "Is Empty!")"

//: And what about check some extra data for debug like print as a json an Encodable Object
struct User: Codable {
    let id: Int
    let name: String
}
let jaime = User(id: 10, name: "JAIME")
//: ```print("Here's some data: \(debug: jaime)")```

extension String.StringInterpolation {
    mutating func appendInterpolation<T: Encodable>(debug value: T) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let result = try encoder.encode(value)
        let str = String(decoding: result, as: UTF8.self)
        appendLiteral(str)
    }
}

print(try "Status check: \(debug: jaime)")

//: we use autoclosure for a default value, we can use it again for if conditions like in nil coalising

let condition = true
"\(condition ? "success" : "failure")"
//"\(if: true, "success", failure)"

extension String.StringInterpolation {
    mutating func appendInterpolation(if condition: @autoclosure () -> Bool,
                                      then trueliteral: StringLiteralType,
                                      else falseliteral: StringLiteralType) {
        if condition() {
            appendLiteral(trueliteral)
        } else {
            appendLiteral(falseliteral)
        }
    }
}

"\(if: 2+2 >= 4, then: "success", else: "failure")"

//: [Next](@next)
