//: [Previous](@previous)

import Foundation
import Combine
import PlaygroundSupport

NotificationCenter.default.publisher(for: .newTrick)
    .compactMap { $0.userInfo }
    .compactMap { $0["data"] as? [AnyHashable : Any] }
    .decode(type: MagicTrick.self, decoder: JSONSerializationDecoder())
//:    - .assertNoFailure()  -> will make the error of Never type
//:   -  .mapError { $0 }
//:   -  .catch { Just(MagicTrick.placeholder) }
//:   - Catch allow to return a new publisher but terminate the other connection
    .replaceError(with: .placeHolder)
//    .catch({ _ in
//        Just(MagicTrick.placeHolder)
//    })
    .print()
    .sink(receiveCompletion: { _ in },
          receiveValue: { _ in })

NotificationCenter.default.post(name: .newTrick,
                                object: nil,
                                userInfo: ["data": ["name": "ocus pocus"]])
//                                userInfo: ["data": ["name": "ocus pocus", "kind": "deadly"]])

/*:
 some operator to control are
 
 - delay
 - debounce
 - throttle
 - receive(on:)
 - subscribre(on:)
 */


//: [Next](@next)
