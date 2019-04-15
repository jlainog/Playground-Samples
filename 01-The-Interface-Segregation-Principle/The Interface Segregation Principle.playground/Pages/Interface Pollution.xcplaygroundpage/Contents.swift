//: [Previous](@previous)

//: # Interface Pollution

protocol Door {
    var isOpen: Bool { get }
    
    func lock()
    func unlock()
}

//: Consider a TimedDoor to sound an Alarm
protocol TimedDoor: Door {}

protocol Timer {
    func register(timeout: Int,
                  client: TimerClient)
}

protocol TimerClient {
    func timeout()
}
/*:
We force Door, and therefore TimedDoor, to inherit from TimerClient.
```
protocol Door: TimerClient {}
TimedDoor -> Door -> TimerClient
```
*/

/*:
 ### Separate Clients mean Separate Interfaces.

For example multiple clients can be registered and we need a way to suppor this
 */
protocol Timer_upgraded {
    func register(timeout: Int,
                  timeoutId: Int,
                  client: TimerClient)
}
protocol TimerClient_upgraded {
    func timeout(id: Int)
}
/*: This affect all users of TimerClient. this can be and expected enhacement but this will also affect Door and clients of Door... Why a bug in TimerClient should affect clients of Doors that dont require timing?

 ### CLIENTS SHOULD NOT BE FORCED TO DEPEND UPON INTERFACES THAT THEY DO NOT USE.
 */

//: [Next](@next)
