/*:
 # Type Erasure
 
 When you are dealing with protocols that either have a Self requirement or an associated type, you cannot use the protocol name as a standalone type anymore.
 
 ## Type Erasure to the rescue!
 
 In programming languages, type erasure refers to the load-time process by which explicit type annotations are removed from a program, before it is executed at run-time.
 */
//: [Next](@next)

protocol MyTable {}

class ATable: MyTable {}
class BTable: MyTable {}

func display(table: MyTable) -> MyTable {
    return table
}

let table = display(table: ATable())

//table: MyTable

let aTable = table as! ATable

let tables: [MyTable] = [ATable(), BTable()] // [MyTables]


protocol Human {
    associatedtype Gender
    var name: String { get }
    func eat()
}

struct Men {}

struct Jaime: Human {
    typealias Gender = Men
    let name: String = "JAIME"
    func eat() { print("\(name) is Eating") }
}
struct David: Human {
    typealias Gender = Men
    let name: String = "David"
    func eat() { print("\(name) is Eating") }
}
struct Juan: Human {
    typealias Gender = Men
    let name: String = "Juan"
    func eat() { print("\(name) is Eating") }
}

func eat() {}
// () -> Void

struct AnyHuman<T>: Human {
    typealias Gender = T
    private var _eat: () -> Void
    var name: String
    
    init<H: Human>(_ human: H) where H.Gender == T {
        self.name = human.name
        self._eat = human.eat
    }
    
    func eat() {
        _eat()
    }
}

extension Human {
    func makeAnyHuman() -> AnyHuman<Gender> {
        return AnyHuman(self)
    }
}

AnyHuman(Jaime())

var men = [Jaime().makeAnyHuman(),
           Juan().makeAnyHuman(),
           David().makeAnyHuman()]

men.forEach { $0.eat() }
