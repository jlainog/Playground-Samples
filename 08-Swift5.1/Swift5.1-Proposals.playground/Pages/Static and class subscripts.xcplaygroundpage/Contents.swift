//: [Previous](@previous)

/*:
 # Static and class subscripts
 Proposal: [SE-0254](https://github.com/apple/swift-evolution/blob/master/proposals/0254-static-subscripts.md)
 */

import Foundation

struct Environment {
    private static var values = [String: String]()
    
    static func get(_ key: String) -> String? {
        values[key]
    }
    static func set(_ key: String, to newValue: String) {
        values[key] = newValue
    }
    
    static subscript(_ key: String) -> String? {
        get {
            values[key]
        }
        set {
            values[key] = newValue
        }
    }
}

Environment["testCase"] = "new Case"
Environment["testCase"]

@dynamicMemberLookup
struct Environment2 {
    private static var values = [String: String]()
    
    static subscript(_ key: String) -> String? {
        get { values[key] }
        set { values[key] = newValue }
    }
    static subscript(dynamicMember name: String) -> String? {
        get { self[name] }
        set { self[name] = newValue }
    }
}

Environment2.testCase = "another Case"
Environment2.testCase

//: [Next](@next)
