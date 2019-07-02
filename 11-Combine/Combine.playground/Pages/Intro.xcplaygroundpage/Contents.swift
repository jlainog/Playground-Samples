//: [Previous](@previous)

import Foundation
import Combine

//: Publishers how values and errors are produced

let publisher = AnyPublisher<String, Never> { subscriber in
    _ = subscriber.receive("NEW")
    subscriber.receive(completion: .finished)
}

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
