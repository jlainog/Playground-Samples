//: [Previous](@previous)

/*:
 # Synthesize default values for the memberwise initializer
 Proposal: [SE0242]( https://github.com/apple/swift-evolution/blob/master/proposals/0242-default-values-memberwise.md)
 */

import Foundation

enum State {
    case none, loggedIn
}
struct User {
    var name: String
    var state: State = .none
}

let worker = User(name: "Tim", state: .loggedIn)
let programmer = User(name: "Ive")

//: [Next](@next)
