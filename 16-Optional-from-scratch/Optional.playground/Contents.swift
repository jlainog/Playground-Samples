import XCTest

/*************
The initializers
**************/

let some: Optional<Int> = 42
let none: Optional<Int> = nil
let str: Optional<String> = "Hello!"
let noneStr: Optional<String> = nil

/*************
 unwrap
**************/

let result1 = some?.distance(to: 10)
let result2 = none?.distance(to: 10)

print("Expecting: Optional(-32), Got: \(String(describing: result1))")
print("Expecting: nil, Got: \(String(describing: result2))")

/*************
 Throwing forceUnwrap
 **************/

XCTAssertThrowsError(none!.distance(to: 42))


/*************
 Comparisons and Equatable conformance.
 **************/

print("Expecting: true, Got: \(none == Optional<Int>(nil))")
print("Expecting: false, Got: \(some == none)")
print("Expecting: true, Got: \(some == Optional<Int>(42))")
print("Expecting: false, Got: \(some == Optional<Int>(41))")
