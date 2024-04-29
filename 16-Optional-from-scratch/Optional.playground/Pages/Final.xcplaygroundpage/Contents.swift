//: [Previous](@previous)

import Foundation

private func emoji(for bool: Bool) -> Character {
    return bool ? "✅" : "❌"
}

enum Optional<Wrapped> {
    case none
    case some(Wrapped)
}

/*
 ************
 initializers
 ************
 */

extension Optional {
    init(_ some: Wrapped) {
        self = .some(some)
    }
}

extension Optional: ExpressibleByNilLiteral {
    init(nilLiteral: ()) {
        self = .none
    }
}

extension Optional: ExpressibleByIntegerLiteral where Wrapped == Int {
    init(integerLiteral value: Int) {
        self = .some(value)
    }
}

extension Optional: ExpressibleByUnicodeScalarLiteral where Wrapped == String {
    init(unicodeScalarLiteral value: String) {
        self = .some(value)
    }
}

extension Optional: ExpressibleByExtendedGraphemeClusterLiteral where Wrapped == String {
    init(extendedGraphemeClusterLiteral value: String) {
        self = .some(value)
    }
}

extension Optional: ExpressibleByStringLiteral where Wrapped == String {
    init(stringLiteral value: StringLiteralType) {
        self = .some(value)
    }
}

//let some = Optional<Int>(42)
let some: Optional<Int> = 42
let none: Optional<Int> = nil
let randomStr: Optional<String> = "Hello!"
let randomNoStr: Optional<String> = nil

/*
 ************
 unwrap
 ************
 */

extension Optional: CustomStringConvertible {
    public var description: String {
        switch self {
        case .some(let value):
            var result = "Optional("
            debugPrint(value, terminator: "", to: &result)
            result += ")"
            return result
        case .none:
            return "nil"
        }
    }
}

postfix operator ❓
postfix func ❓<Wrapped>(optional: Optional<Wrapped>) -> Wrapped {
    switch optional {
    case .some(let value):
        return value
    case .none:
        fatalError()
//        return nil
    }
}

let result1 = some❓.distance(to: 10)
String(describing: result1)
emoji(for: "Optional(-32)" == String(describing: result1))

extension Optional {
    func map<T>(_ transform: (Wrapped) -> T) -> Optional<T> {
        switch self {
        case .some(let value):
            return Optional<T>(transform(value))
        case .none:
            return nil
        }
    }
}

let result2 = none.map { $0.distance(to: 10) }
//let result2 = none❓.distance(to: 10)
emoji(for: "nil" == String(describing: result2))

let result3 = some.map { $0.distance(to: 10) }
String(describing: result3)
emoji(for: "Optional(-32)" == String(describing: result3))

/*
 ************
 Throwing forceUnwrap
 ************
 */

postfix operator ❗️
postfix func ❗️<Wrapped>(optional: Optional<Wrapped>) throws -> Wrapped {
    switch optional {
    case .some(let value):
        return value
    case .none:
        throw NSError(domain: "OptionalError", code: 0)
    }
}

do {
    _ = try none❗️.distance(to: 42)
   emoji(for: false)
} catch {
    emoji(for: true)
}

/*
 ************
 Comparisons and Equatable conformance.
 ************
 */

extension Optional: Equatable where Wrapped: Equatable {
    static func ==(lhs: Optional<Wrapped>, rhs: Optional<Wrapped>) -> Bool {
        switch (lhs, rhs) {
        case let (.some(l), .some(r)):
            return l == r
        case (.none, .none):
            return true
        default:
            return false
        }
    }
}

extension Optional: Comparable where Wrapped: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.some(l), .some(r)):
            return l < r
        default:
            return false
        }
    }

    static func <= (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.some(l), .some(r)):
            return l <= r
        default:
            return false
        }
    }

    static func >= (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.some(l), .some(r)):
            return l >= r
        default:
            return false
        }
    }

    static func > (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.some(l), .some(r)):
            return l > r
        default:
            return false
        }
    }
}

emoji(for: none == Optional<Int>(nil))
emoji(for: some != none)
emoji(for: some == Optional<Int>(42))
emoji(for: some != Optional<Int>(41))

/*
 ************
 Nil-Coalescing
 ************
 */

infix operator ❓❓
func ❓❓<Wrapped>(optional: Optional<Wrapped>, default: @autoclosure () -> Wrapped) -> Wrapped {
    switch optional {
    case .some(let value):
        return value
    case .none:
       return `default`()
    }
}

let result4 = some ❓❓ 50
let result5 = none ❓❓ 50


//: [Next](@next)
