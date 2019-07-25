//: [Previous](@previous)

/*:
 # Property wrappers (formerly known as Property Delegates)
 Proposal: [SE-0258](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md)
 */


import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
        UserDefaults.standard.register(defaults: [key: defaultValue])
    }

    public var projectedValue: Self {
      get { self }
      set { self = newValue }
    }
}

struct Settings {
    @UserDefault("tokenTime", defaultValue: 300)
    static var tokenTime: TimeInterval {
        willSet {
            print("Will Set Token Time")
        }
        didSet {
            print("Did Set Token Time")
        }
    }
    
    @UserDefault("UserLogged", defaultValue: false)
    static var isLogged: Bool
}

Settings.tokenTime
Settings.tokenTime = 10

//:  use  the prefix $ to synthesize the storage property name
Settings.$tokenTime.key
Settings.$tokenTime.wrappedValue
Settings.$tokenTime.defaultValue

/*:
 Codable, Hashable, and Equatable synthesis
 
 Synthesis for Encodable, Decodable, Hashable, and Equatable use the backing storage property. This allows property wrapper types to determine their own serialization and equality behavior. For Encodable and Decodable, the name used for keyed archiving is that of the original property declaration (without the $).
 */

@propertyWrapper
enum Lazy<Value> {
    case uninitialized(() -> Value)
    case initialized(Value)
    
    init(initialValue: @autoclosure @escaping () -> Value) {
        self = .uninitialized(initialValue)
    }
    
    var wrappedValue: Value {
        mutating get {
            switch self {
            case .uninitialized(let initializer):
                let value = initializer()
                self = .initialized(value)
                return value
            case .initialized(let value):
                return value
            }
        }
        set {
            self = .initialized(newValue)
        }
    }
}

//: Copy on Write
protocol Copyable: AnyObject {
    func copy() -> Self
}

@propertyWrapper
struct CopyOnWrite<Value: Copyable> {
    init(initialValue: Value) {
        _value = initialValue
    }
    
    private(set) var _value: Value
    
    var wrappedValue: Value {
        mutating get {
            if !isKnownUniquelyReferenced(&_value) {
                _value = _value.copy()
            }
            return _value
        }
        set {
            _value = newValue
        }
    }
}

//: "Clamping" a value within bounds
@propertyWrapper
struct Clamping<V: Comparable> {
    var _value: V
    let min: V
    let max: V
    
    init(initialValue: V, min: V, max: V) {
        _value = initialValue
        self.min = min
        self.max = max
        assert(_value >= min && _value <= max)
    }
    
    var wrappedValue: V {
        get { return _value }
        set {
            if newValue < min {
                _value = min
            } else if newValue > max {
                _value = max
            } else {
                _value = newValue
            }
        }
    }

    public var projectedValue: Self {
      get { self }
      set { self = newValue }
    }
}

struct ClampColor {
    @Clamping(min: 0, max: 255) var red: Int = 127
    @Clamping(min: 0, max: 255) var green: Int = 127
    @Clamping(min: 0, max: 255) var blue: Int = 127
    @Clamping(min: 0, max: 255) var alpha: Int = 255
    
    init(red: Int = 127, green: Int = 127, blue: Int = 127, alpha: Int = 255) {
        $red = Clamping(initialValue: red, min: 0, max: 255)
        $green = Clamping(initialValue: green, min: 0, max: 255)
        $blue = Clamping(initialValue: blue, min: 0, max: 255)
        $alpha = Clamping(initialValue: alpha, min: 0, max: 255)
    }
}

@propertyWrapper
struct Expirable<T> {
    private var now: Date { Date() }
    private var expirationDate: Date = Date()
    private var concreteValue: T? = nil
    private var isValid: Bool { now < expirationDate }
    
    let duration: TimeInterval
    var wrappedValue: T? {
        get { isValid ? concreteValue : nil }
        set {
            expirationDate = now.addingTimeInterval(duration)
            concreteValue = newValue
        }
    }
    
    init(seconds: TimeInterval) {
        self.duration = seconds
    }
}

struct Token {
    @Expirable(seconds: 3)
    static var auth: String?
}

Token.auth
Token.auth = "some token"

sleep(2)
Token.auth
sleep(2)
Token.auth

@propertyWrapper
struct AssertOnQueue<Value> {
    private var _value: Value
    private var _expectedQueue: DispatchQueue
    
    init(initialValue: Value, queue: DispatchQueue) {
        _value = initialValue
        _expectedQueue = queue
    }
    
    var wrappedValue: Value {
        get {
            __dispatch_assert_queue(_expectedQueue)
            return _value
        }
        
        set {
            __dispatch_assert_queue_barrier(_expectedQueue)
            _value = newValue
        }
    }
}

@propertyWrapper
struct ThreadSafe<Value> {
    private var _value: Value
    private var queue: DispatchQueue
    
    init(initialValue: Value, queue: DispatchQueue = .main) {
        _value = initialValue
        self.queue = queue
    }
    
    var wrappedValue: Value {
        get {
            var concreteValue: Value?
            
            queue.sync {
                concreteValue = _value
            }
            return concreteValue!
        }
        
        set {
            queue.sync(flags: .barrier) {
                self._value = newValue
            }
        }
    }
}

import UIKit
@ThreadSafe var myproperty: UIView = UIView()

@ThreadSafe(initialValue: .init(), queue: .global())
var myproperty2: UIView

//: [Next](@next)
