import UIKit
import Combine

let publisher = AnyPublisher<String, Never> { subscriber in
    _ = subscriber.receive("NEW")
    subscriber.receive(completion: .finished)
}

publisher
    .sink { (value) in
        print(value)
}

extension NotificationCenter {
    struct Publisher: Combine.Publisher {
        typealias Output = Notification
        typealias Failure = Never
        let center: NotificationCenter
        let name: Notification.Name
        let object: Any?

        init(center: NotificationCenter, name: Notification.Name, object: Any? = nil) {
            self.center = center
            self.name = name
            self.object = object
        }
        
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


    final class Assign<Root, Input>: Subscriber, Cancellable {
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

        func cancel() {

        }
    }

extension Notification.Name {
    static let change = Notification.Name("Change")
}

class Wizzard {
    var grade: Int = 5
}
let merlin = Wizzard()

//let gradePublisher = NotificationCenter.Publisher(center: .default, name: .change, object: merlin)
//let gradeSubscriber = Assign(object: merlin, keyPath: \.grade)
//let converter = Publishers.Map(upstream: gradePublisher) { notification in
//    notification.userInfo["NewGrade"] as? Int ?? 0
//}
//converter.subscribe(gradeSubscriber)

/// VS

let cancellable = NotificationCenter
    .Publisher(center: .default, name: .change, object: nil)
    .compactMap { (notification) in
        notification.userInfo?["NewGrade"] as? Int
    }
    .filter { $0 < 5 }
    .prefix(3)
    .assign(to: \.grade, on: merlin)

/// notification center look inside use filter
/// result of severar network operations use Zip
/// network results use decode

//NotificationCenter.default.publisher(for: .change)
//    .compactMap { $0.userInfo?["NewGrade"] as? Int }
//    .assign(to: \.grade, on: merlin)

NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 1])
NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 2])
//NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 3])
NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 4])
NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 5])
NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 6])
NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 7])
//NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 8])
//NotificationCenter.default.post(name: .change, object: nil, userInfo: ["NewGrade": 9])
merlin.grade
