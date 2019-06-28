//: [Previous](@previous)

/*:
 # Implicit returns from single-expression functions
 Proposal: [SE-0255](https://github.com/apple/swift-evolution/blob/master/proposals/0255-omit-return.md)
 */

import Foundation

let sum = [1,2,3,4].reduce(0) { $0 + $1 }
let sum1 = [1,2,3,4].reduce(0) { return $0 + $1 }

extension Sequence where Element == Int {
    func sum() -> Element {
        return reduce(0, +)
    }
    func sum1() -> Element {
        reduce(0, +)
    }
}

func add(lhs: Int, rhs: Int) -> Int { lhs + rhs }

var newValue: Int { 0 }


//: [Next](@next)
