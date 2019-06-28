//: [Previous](@previous)

/*:
 # Add an Array Initializer with Access to Uninitialized Storage
 Proposal: [SE-0245](https://github.com/apple/swift-evolution/blob/master/proposals/0245-array-uninitialized-initializer.md))
 
 This proposal suggests a new initializer for Array and ContiguousArray that provides access to an array's uninitialized storage buffer.
 */

import Foundation

var myArray = Array<Int>(unsafeUninitializedCapacity: 10) { buffer, initializedCount in
    for x in 1..<5 {
        buffer[x] = x
    }
    buffer[0] = 10
    initializedCount = 5
}
// myArray == [10, 1, 2, 3, 4]

//: [Next](@next)
