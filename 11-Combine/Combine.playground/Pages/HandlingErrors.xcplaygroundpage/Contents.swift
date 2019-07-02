//: [Previous](@previous)

import Foundation
import Combine

NotificationCenter.default.publisher(for: .newTrick)
    .map { $0.userInfo!["data"] as! Data }
    .decode(type: MagicTrick.self, decoder: JSONDecoder())
//    .catch { Just(MagicTrick.placeholder) }

//: [Next](@next)
