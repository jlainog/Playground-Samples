import Foundation
/*:
 ## The Algebra of Data Types
 
 To know more check:
 
 - “The Algebra of Data Types” From: Chris Eidhof. “Functional Swift.”
 - [Algebraic Data Types](https://www.pointfree.co/episodes/ep4-algebraic-data-types)
 - [Making Illegal States Unpresentable](https://oleb.net/blog/2018/03/making-illegal-states-unpresentable/)
 - [Case Study: Algebraic Data Types](https://www.pointfree.co/blog/posts/2-case-study-algebraic-data-types)
*/

enum Add<A, B> {
    case left(A)
    case right(B)
}

enum Three {
    case one, two, three
}

Add<Bool, Three>.left(true)
Add<Bool, Three>.left(false)

Add<Bool, Three>.right(.one)
Add<Bool, Three>.right(.two)
Add<Bool, Three>.right(.three)
// 2 + 3
Add<Bool, Never>.left(true)
Add<Bool, Never>.left(false)
//Add<Bool, Never>.right(??)
// 2 + 0

typealias Times<A, B> = (A, B)

//Times<Bool, Three>
Times<Bool, Three>(true, .one)
Times<Bool, Three>(true, .two)
Times<Bool, Three>(true, .three)
Times<Bool, Three>(false, .one)
Times<Bool, Three>(false, .two)
Times<Bool, Three>(false, .three)
// true && one
// true && two
// true && three
// false && one
// false && two
// false && three
// 2 * 3
typealias One = () // Void
Times<Bool, One>(true, One())
Times<Bool, One>(false, One())
// 2 * 1
Times<Bool, Void>(false, Void())

//Times<Bool, Never>(true, ???)
// 2 * 0 = 0
//Times<Bool, Never>(true, fatalError())

struct Pair<A, B> {
    let a: A
    let b: B
}

Pair<Bool, Three>.init(a: true, b: .one)
// Bool * Three

enum Never {}
struct Unit {}

Unit()
Pair<Bool, Unit>.init(a: true, b: Unit())

Pair<Times<Bool,Bool>, Bool>.init(a: (true, false), b: true)
// (2 * 2) * 2
Pair<Add<Bool, Bool>, Bool>.init(a: .left(true), b: true)
// (2 + 2) * 2

enum Optional<Wrapped> {
    case none
    case some(Wrapped)
}
Optional<Bool>.none
Optional<Bool>.some(true)
//Optional<Bool> = 1 + 2
//Optional< ? >  = 1 + ?

typealias handler = (Success: Bool?, Error?, ErrorMessage: String?)
// (Bool + 1) * (Error + 1) * (String + 1)
// Success * Error * ErrorMessage -> No
// + Success * ErrorMessage -> No
// + Error * ErrorMessage -> Si
// + Success * ErrorMessage -> No
// + Success -> Si
// + Error -> Si
// + ErrorMessage -> No
// + 1 -> No

typealias ExpedtedHandler = ((Bool), (Error, ErrorMessage: String?))
// -> Pair<Bool, (Error, String?)>
// Success * (Error * (ErrorMessage + 1))

typealias RealHandler = Add<Bool, (Error, String?)>
// Success + (Error * (ErrorMessage + 1))
// -> Result<Bool, (Error, String?)>
// Success
// + Error * ErrorMessage
// + Error
