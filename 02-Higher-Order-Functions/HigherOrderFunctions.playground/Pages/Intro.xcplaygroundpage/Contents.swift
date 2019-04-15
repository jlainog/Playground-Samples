/*:
 # Higher-order functions
 
 ### In mathematics and computer science, a higher-order function is a function that does at least one of the following:
 - Takes one or more functions as arguments (i.e. procedural parameters)
 
 `(A -> B) -> C`
 - Returns a function as its result.
 
 `(A) -> ((B) -> C)`

 All other functions are first-order functions.
 */
func someHighOrderFunction(_ f: (String) -> Int) -> Int {
    return f("10")
}
someHighOrderFunction { string in Int(string) ?? 0 }

func otherHighOrderFunction(_ a: Int) -> ((String) -> Int) {
    return { string in a + (Int(string) ?? 0) }
}
otherHighOrderFunction(10)("10")
//: [Next](@next)
