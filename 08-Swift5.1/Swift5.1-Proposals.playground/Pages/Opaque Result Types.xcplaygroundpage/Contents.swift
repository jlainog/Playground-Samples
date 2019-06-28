//: [Previous](@previous)

/*:
 # Opaque Result Types
 Proposal: [SE-0244](https://github.com/apple/swift-evolution/blob/master/proposals/0244-opaque-result-types.md)
 */

import Foundation

protocol Shape {
    //    associatedtype View
    //
    //    func draw(to: View)
    init()
}

struct Rectangle: Shape { }
struct Circle: Shape { }

func makeShape() -> some Shape {
    return Rectangle()
}
let rect = makeShape()

func makeShape<T: Shape>() -> T {
    T()
}
let rect2: Rectangle = makeShape()

func makeInt() -> some Equatable {
    return Int.random(in: 1...100)
}
let a = makeInt()
let b = makeInt()
assert(a != b)

//: [Next](@next)
