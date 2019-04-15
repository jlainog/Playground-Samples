import Foundation

/*:
 # Exploring KeyPaths
 [Link to key-path_expressions](https://developer.apple.com/documentation/swift/swift_standard_library/key-path_expressions)
 */
/*:
 A Key Path is a way to detail a value from a root
 ```
 KeyPath<Root, Value>
 ```
 It is a key path from a specific root type to a specific resulting value type.
 
 Use key-path expressions to access properties dynamically.
 */


struct User {
    var username: String
    var followersCount: Int
}

var someUser = User(username: "JAIME", followersCount: 29)

someUser[keyPath: \User.username]

//: Type-Erased read ONLY from any root type to any resulting value type.
//: anyKeyPath: Hashable, _AppendKeyPath
let anyKeyPath: AnyKeyPath = \User.followersCount
someUser[keyPath: anyKeyPath]
//: PartialKeyPath: AnyKeyPath -> partially type-erased
let partialKeyPath: PartialKeyPath<User> = \.followersCount
let userPaths: [PartialKeyPath<User>] = [
    \User.username,
    \User.followersCount
]
//: KeyPath: PartialKeyPath
let keyPath: KeyPath<User, Int> = \.followersCount
someUser[keyPath: keyPath]
//: WritableKeyPath: KeyPath -> supports reading and writing
let writableKeyPath: WritableKeyPath<User, Int> = \User.followersCount
someUser[keyPath: writableKeyPath] = 10
//: ReferenceWritableKeyPath: WritableKeyPath -> supports reading and writing with reference semantics.
class ClassUser {
    var username: String = "ClassUser-username"
}
let referenceWritableKeyPath: ReferenceWritableKeyPath<ClassUser, String> = \ClassUser.username
var someclassUser = ClassUser()
someclassUser[keyPath: referenceWritableKeyPath]
someclassUser[keyPath: referenceWritableKeyPath] = "NewName"
/*: Append keypaths
The root of the KeyPath to append needs to correspond with the Value of the KeyPath is going to be appended to.
 */
struct Account {
    var user: User
}
let someAccount = Account(user: someUser)
let accountUserKeyPath = \Account.user
let accountUsernameKeyPath = accountUserKeyPath.appending(path: \User.username)
someAccount[keyPath: accountUsernameKeyPath]
//: you can use it to ask for the same property in several places and change them all just with one line
let someUsers = [
    User(username: "New0", followersCount: 10),
    User(username: "New2", followersCount: 0),
    User(username: "New3", followersCount: 9),
    User(username: "New4", followersCount: 8),
    User(username: "New4", followersCount: 3),
    User(username: "New5", followersCount: 4),
    User(username: "New6", followersCount: 2),
    User(username: "New7", followersCount: 1),
]
let someUserKeyPath = userPaths.first! //First are names, Last are followersCount
someUser[keyPath: someUserKeyPath]

let usernames = someUsers.map { $0.username }
let userPropertyValue = someUsers.map { $0[keyPath: someUserKeyPath] }
userPropertyValue
/*:
 you create helper functions to do the same with a easy to read syntax
 */
extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }
    
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}

someUsers.map(\.username)
someUsers.sorted(by: \.followersCount)
//: Or Create Functions that abstract the depending types
protocol MediaView: class {
    var title: String { get set }
    var raiting: String { get set }
}

struct MediaViewSetup<Model> {
    let titleKeyPath: KeyPath<Model, String>
    let raitingKeyPath: KeyPath<Model, Int>
    
    func setup(_ view: MediaView, for model: Model) {
        view.title = model[keyPath: titleKeyPath]
        view.raiting = "raiting: \(model[keyPath: raitingKeyPath])"
    }
}

struct Movie {
    var title = "MovieTitle"
    var raiting = 10
}

struct Series {
    var title = "Padres e Hijos"
    var raiting = 0
}

let movieViewSetup = MediaViewSetup<Movie>(titleKeyPath: \.title,
                                           raitingKeyPath: \.raiting)
let seriesViewSetup = MediaViewSetup<Series>(titleKeyPath: \.title,
                                            raitingKeyPath: \.raiting)

//: Since it has the same properties you can declare a protocol for that interface and make the keyPath constants for the new type
protocol Media {
    var title: String { get set }
    var raiting: Int { get set }
}

struct MediaViewSetter {
    let titleKeyPath: KeyPath<Media, String> = \.title
    let raitingKeyPath: KeyPath<Media, Int> = \.raiting
    
    func setup(_ view: MediaView, for model: Media) {
        view.title = model[keyPath: titleKeyPath]
        view.raiting = "raiting: \(model[keyPath: raitingKeyPath])"
    }
}
/*:
 ```
 MediaViewSetter().setup(someView, for: aMediaModel)
 ```
 */
//: Also create Setters for a given object
func setter<Object: AnyObject, Value>
    (for object: Object,
     keyPath: ReferenceWritableKeyPath<Object, Value>) -> (Value) -> Void {
    return { [weak object] value in
        object?[keyPath: keyPath] = value
    }
}

let someSetter = setter(for: someclassUser, keyPath: \.username)
someSetter("New Name using Setter")
someclassUser.username

struct UserLoader {
    static func getName(_ id: Int, handler: (String) -> Void) {
        handler("UserLoader returned name")
    }
}

UserLoader.getName(0) { (name) in
    someclassUser.username = name
}
//: VS
UserLoader.getName(0, handler: someSetter)
//: Or
UserLoader.getName(0, handler: setter(for: someclassUser, keyPath: \.username))
someclassUser.username

//: Now create Setters for a given struct
func prop<Root, Value>(_ keyPath: WritableKeyPath<Root, Value>)
    -> (@escaping (Value) -> Value)
    -> (Root)
    -> Root {
        return { update in
            { root in
                var copy = root
                let copyValue = copy[keyPath: keyPath]
                
                copy[keyPath: keyPath] = update(copyValue)
                return copy
            }
        }
}

//let someSetter = setter(for: someclassUser, keyPath: \.username)
someSetter("New Name using Setter")
someclassUser.username

let propNameSetter = prop(\User.username)
let newNameSetter = propNameSetter { _ in "New name using Setter" }
let newUser = newNameSetter(someUser)
[someUser, someUser].map(newNameSetter).map(\.username)
//: Also the closures can be inverted to link the change to a given struct
func propInverted<Root, Value>(_ keyPath: WritableKeyPath<Root, Value>)
    -> (Root)
    -> (@escaping (Value) -> Value)
    -> Root {
        return { root in
            { update in
                var copy = root
                let copyValue = copy[keyPath: keyPath]
                
                copy[keyPath: keyPath] = update(copyValue)
                return copy
            }
        }
}

let propInvertedSetter = propInverted(\User.username)(someUser)
propInvertedSetter { $0.uppercased() }
propInvertedSetter { _ in "new user name" }

//: And a get function can be created as well
func get<Root, Value>(_ kp: KeyPath<Root, Value>) -> (Root) -> Value {
    return { root in
        root[keyPath: kp]
    }
}
let kp = \User.username
get(kp)
someUser[keyPath: kp]
get(kp)(someUser)

[someUser, someUser].map(get(kp))
//: With this we no longer need to create versions of map, sort, filter ... to take a KeyPath as the argument, it just need to pass the get()

