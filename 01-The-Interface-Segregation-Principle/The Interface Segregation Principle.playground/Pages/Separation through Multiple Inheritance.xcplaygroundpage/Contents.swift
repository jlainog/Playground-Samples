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

//: # Separation through Multiple Inheritance
protocol TimedDoor: Door, TimerClient {
    func doorTimeOut(_ id: Int)
}
/*:
 Here TimedDoor inherits from both Door and TimerClient neither of those depend upon the TimedDoor. They use the same object through separate interfaces.
 
 This is the normal most common solution. You would choose delegation if the translation performed by the Adapter object is necessary, or if different translations are needed at different times.
 */
//: [Next](@next)
