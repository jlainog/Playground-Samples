//: [Previous](@previous)

import Foundation
import SwiftUI
import Combine

//: Publishers how values and errors are produced
struct StringPublisher: Publisher {
    typealias Output = String
    typealias Failure = Never
    
    func receive<S>(subscriber: S) where S : Subscriber, StringPublisher.Failure == S.Failure, StringPublisher.Output == S.Input {
        subscriber.receive("New")
        subscriber.receive(completion: .finished)
    }
}

let publisher = StringPublisher()

//: Subscriber

publisher
    .sink { print($0) }

//: Operators
//: adopts Publisher

publisher
    .map { "Mapping " + $0 }
    .print()
    .sink { _ in }

//: [Next](@next)
