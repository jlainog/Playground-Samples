//: [Previous](@previous)
import Foundation
/*:
 # Playing with High Order Functions
 Taken from [ep5-higher-order-functions](https://www.pointfree.co/episodes/ep5-higher-order-functions)
 */
/*:
 ## Curry
 In mathematics and computer science, currying is the technique of translating the evaluation of a function that takes multiple arguments into evaluating a sequence of functions, each with a single argument.
 
 A curried function is a function that takes multiple arguments one at a time.
 */
//: Example
func isMultipleOf(_ n: Int) -> (Int) -> Bool {
    return { $0 % n == 0 }
}

[1,2,3,4,5,6,7,8,9].filter(isMultipleOf(2))
/*:
 Create a function to curry a function with 2 arguments
 
 Given:
 
 String.init(data: encoding:)
 
 (Data, Encoding) -> String?
 
 Translate to:
 
 (Data) -> (Encoding) -> String?
 */
func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { b in f(a, b) } }
}
var stringInitWithDataAndEncoding = curry(String.init(data: encoding:))

let stringData = "JAIME".data(using: .utf8)!
stringInitWithDataAndEncoding(stringData)(.utf8)

func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
    return { b in { a in f(a)(b) } }
}

var flipedStringInit = flip(stringInitWithDataAndEncoding)
//: (Encoding)-> (Data) -> String?
flipedStringInit(.utf8)(stringData)
//: [Next](@next)
