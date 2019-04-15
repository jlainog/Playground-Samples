//: [Previous](@previous)
protocol Door {
    func lock()
    func unlock()

    var isOpen: Bool { get }
}

protocol TimerClient {
    func timeout(_ id: Int)
}

class Timer {
    func register(timeout: Int,
                  timeoutId: Int,
                  client: TimerClient) {}
}
//: # Separation through Delegation
struct TimedDoor: Door {
    var isOpen: Bool = false
    
    func lock() {}
    func unlock() {}
    func doorTimeOut(_ id: Int) {}
}

class DoorTimerAdapter: TimerClient {
    private var timedDoor: TimedDoor
    
    init(door: TimedDoor) {
        timedDoor = door
    }

    func timeout(_ id: Int) {
        timedDoor.doorTimeOut(id)
    }
}
//: This solution conforms to the ISP and prevents the coupling of Door clients to Timer.
let timedDoor = TimedDoor()
let adapter = DoorTimerAdapter(door: timedDoor)
Timer().register(timeout: 10,
                 timeoutId: 1,
                 client: adapter)
//: However, this solution is also somewhat inelegant. It involves the creation of a new object every time we wish to register a timeout. Delegation also requires a small amount of runtime memory, in some systems which runtime and memory are scarce this became a concern.

//: [Next](@next)
