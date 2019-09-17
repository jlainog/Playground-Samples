//: [Previous](@previous)

import Foundation
import Combine

//: Publisher
extension NotificationCenter {
    struct Publisher: Combine.Publisher {
        typealias Output = Notification
        typealias Failure = Never
        
        let center: NotificationCenter
        let name: Notification.Name
        let object: Any?
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            center.addObserver(forName: name,
                               object: object,
                               queue: nil)
            { (notification) in
                subscriber.receive(notification)
                subscriber.receive(completion: .finished)
            }
        }
    }
}

//: Subscriber
extension Subscribers {
    final class MyAssign<Root, Input>: Subscriber, Cancellable {
        typealias Failure = Never
        
        let object: Root
        let path: ReferenceWritableKeyPath<Root, Input>
        
        init(object: Root, keyPath: ReferenceWritableKeyPath<Root, Input>) {
            self.object = object
            self.path = keyPath
        }
        
        func receive(subscription: Subscription) {
            subscription.request(.unlimited)
        }
        
        func receive(_ input: Input) -> Subscribers.Demand {
            object[keyPath: path] = input
            return .unlimited
        }
        
        func receive(completion: Subscribers.Completion<Never>) {
            switch completion {
            case .finished: break
            default: break
            }
        }
        
        func cancel() {}
    }
}

//: Operators
extension Publishers {
    public struct MyMap<Upstream, Output> : Publisher where Upstream : Publisher {
        public typealias Failure = Upstream.Failure
        public let upstream: Upstream
        public let transform: (Upstream.Output) -> Output
        
        public func receive<S>(subscriber: S) where Output == S.Input, S : Subscriber, Upstream.Failure == S.Failure {}
    }
}

let merlin = Wizzard()

let gradePublisher = NotificationCenter.Publisher(center: .default, name: .change, object: merlin)
let gradeSubscriber = Subscribers.MyAssign(object: merlin, keyPath: \.grade)
let converter = Publishers.MyMap(upstream: gradePublisher) { notification in
    (notification.userInfo?["NewGrade"] as? Int) ?? 0
}
converter.subscribe(gradeSubscriber)

//: VS

let cancellable = NotificationCenter.default
    .publisher(for: .change)
    .compactMap { $0.userInfo?["NewGrade"] as? Int }
    .print()
    .filter { $0 < 5 }
    .prefix(3)
    .assign(to: \.grade, on: merlin)

NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 1])
NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 2])
NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 3])
NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 4])
NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 5])
NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 6])
NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 7])
NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 8])
NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 9])

merlin.grade

cancellable.cancel()
//: [Next](@next)
