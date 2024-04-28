//: [Previous](@previous)

import XCTest

/*
 ************
 initializers
 *************
 */

let some: Optional<Int> = 42
let none: Optional<Int> = nil
let randomStr: Optional<String> = "Hello!"
let randomNoStr: Optional<String> = nil

/*
 ************
 unwrap
 *************
 */

let result1 = some?.distance(to: 10)
let result2 = none?.distance(to: 10)

XCTAssertEqual("Optional(-32)", String(describing: result1))
XCTAssertEqual("nil", String(describing: result2))

/*
 ************
 Throwing forceUnwrap
 *************
 */

XCTAssertThrowsError(none!.distance(to: 42))

/*
 ************
 Comparisons and Equatable conformance.
 *************
 */
XCTAssertTrue(none == Optional<Int>(nil))
XCTAssertFalse(some == none)
XCTAssertTrue(some == Optional<Int>(42))
XCTAssertFalse(some == Optional<Int>(41))

//: [Next](@next)
