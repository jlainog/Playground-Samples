//: [Previous](@previous)

/*:
 # Expanding Swift Self to class members and value types
 Proposal: [SE-0068](https://github.com/apple/swift-evolution/blob/master/proposals/0068-universal-self.md)
 */

import Foundation

class BaseVC {
    class var minConfiguration: Int {
        return 1
    }
    
    func debugMinConfiguration() -> Int {
        //        return BaseVC.minConfiguration
        return Self.minConfiguration
    }
}

class ConcreteVC: BaseVC {
    override class var minConfiguration: Int {
        return 5
    }
}

BaseVC().debugMinConfiguration()
ConcreteVC().debugMinConfiguration()
//: [Next](@next)
