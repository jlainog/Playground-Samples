//: [Previous](@previous)

import Foundation
import Combine

NotificationCenter.default.publisher(for: .newTrick)
    .map { $0.userInfo!["data"] as! Data }
    .decode(type: MagicTrick.self, decoder: JSONDecoder())
//:    - .assertNoFailure()  -> will make the error of Never type
//:   -  .mapError { $0 }
//:   -  .catch { Just(MagicTrick.placeholder) }
//:   - Catch allow to return a new publisher but terminate the other connection
//:   - Flat map allow you to return another publisher in case something happend with out terminate the current connection
//    .flatMap {
//        Just(data)
//        .decode(type: MagicTrick.self, decoder: JSONDecoder())
//        .catch { Just(MagicTrick.placeholder) }
//}
.publisher(for: \.name) // produce a publisher for the keypath, in this case for strings


/*:
 some operator to control are
 
 - delay
 - debounce
 - throttle
 - receive(on:)
 - subscribre(on:)
 */

NotificationCenter.default.publisher(for: .newTrick)
    .map { $0.userInfo!["data"] as! Data }
    .decode(type: MagicTrick.self, decoder: JSONDecoder())
//    .flatMap {
//        Just(data)
//        .decode(type: MagicTrick.self, decoder: JSONDecoder())
//        .catch { Just(MagicTrick.placeholder) }
//}
.publisher(for: \.name)
//.receive(on: Scheduler)


//: [Next](@next)
