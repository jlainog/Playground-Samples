//: [Previous](@previous)
/*:
 # MOCK VS STUB VS SPY
 
 ## A Mock is a dummy class replacing a real one
 ### Use Mocks to:

 * verify the contract for the code under test
  */
protocol User {
    var name: String { get }
    var isLogged: Bool { get }
}
struct MockUser: User {
    let name = "Jaime"
    let isLogged = false
}
/*:
 ## A Stub is also a dummy class simulating specific behaviour.
 ### Use Stubs to:

 * provide a predetermined response from a collaborator
 * take a predetermined action, like throwing an exception
 */
protocol UserService {
    func login(with handler: (Bool) -> Void)
}
struct UserServiceStub: UserService {
    func login(with handler: (Bool) -> Void) {
        handler(false)
    }
}
/*:
 ## A Spy is kind of a hybrid between real object and stub
 ### Use Spies to:

 * verify the a method is called the correct number of times
 * verify the a method is called with the correct parameters
 */
protocol UserAnalytics {
    func logUserDidLogin()
}
class UserAnalyticsSpy: UserAnalytics {
    var didCallLogUserDidLogin = false
    func logUserDidLogin() { didCallLogUserDidLogin = true }
}
//: [Next](@next)
