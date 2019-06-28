//: [Previous](@previous)

/*:
 # Ordered Collection Diffing
 Proposal: [SE-0240](https://github.com/apple/swift-evolution/blob/master/proposals/0240-ordered-collection-diffing.md)
 */

import Foundation

var initialValues = [1,2,3,4,5,6,7]
let finalValues = [5,3,4,5,7,8,9]

if #available(iOS 9999, *) {
    let diff = finalValues.difference(from: initialValues)
    
    for change in diff {
        switch change {
        case .remove(let index, _, _):
            initialValues.remove(at: index)
        case .insert(let index, let element, _):
            initialValues.insert(element, at: index)
        }
    }
    initialValues
    
    initialValues = [1,2,3,4,5,6,7]
    let diff2 = finalValues.difference(from: initialValues)
    let newValues = initialValues.applying(diff2)
    
    newValues
}

//: [Next](@next)
