//: [Previous](@previous)

import Foundation

struct Request<Result> { }

let r1 = Request<Int>()
let r2 = Request<Int>()
let r3 = Request<Int>()
let r4 = Request<Int>()
let r5 = Request<Int>()
let r6 = Request<Int>()
let r7 = Request<Int>()
let r8 = Request<Int>()

struct Evaluator {
    func evaluate<Result>(_: Request<Result>) -> (Result) { fatalError() }
    func evaluate<R1, R2>(_: Request<R1>, _: Request<R2>) -> (R1, R2) { fatalError() }
    func evaluate<R1, R2, R3>(_: Request<R1>, _: Request<R2>, _: Request<R3>) -> (R1, R2, R3) { fatalError() }
    func evaluate<R1, R2, R3, R4>(_: Request<R1>, _: Request<R2>, _: Request<R3>, _: Request<R4>)-> (R1, R2, R3, R4) { fatalError() }
    func evaluate<R1, R2, R3, R4, R5>(_: Request<R1>, _: Request<R2>, _: Request<R3>, _: Request<R4>, _: Request<R5>) -> (R1, R2, R3, R4, R5) { fatalError() }
}

let result1 = Evaluator().evaluate(r1,r2,r3,r4,r5)
//let result1 = Evaluator().evaluate(r1,r2,r3,r4,r5,r6) // Extra argument in call

struct NewEvaluator {
    func evaluate<each Result>(_: repeat Request<each Result>) -> (repeat each Result) { fatalError() }
}

let result2 = NewEvaluator().evaluate(r1,r2,r3,r4,r5,r6,r7,r8)

//: [Next](@next)
