//: [Previous](@previous)
/*:
 # .reduce
 */
let initalValue = 0
let intArray = [10,20,45,32]
let reduceSum = intArray.reduce(initalValue, { $0 + $1 })
let reduceSimplifiedSum = intArray.reduce(initalValue, +)
reduceSum

func sum(moneyArray: [Int]) -> Int {
    var sum = 0
    
    for money in moneyArray {
        sum = sum + money
    }
    
    return sum
}

sum(moneyArray: intArray)

intArray.reduce([]) { (result, iter) in
    print("result \(result)")
    print(iter)
    return result + [iter]
}

let comb = (0..<4).reduce([Int]()) { (combinations, value) in
    return combinations + [value + 5]
}

print(comb)
//: [Next](@next)
