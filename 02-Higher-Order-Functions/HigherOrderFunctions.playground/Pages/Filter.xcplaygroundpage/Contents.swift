//: [Previous](@previous)
/*:
 # .filter
 */
let intArray = [10,20,45,32]
let g = { $0 > 30 }
let filter = intArray.filter(g)

func filter(moneyArray: [Int]) -> [Int] {
    var filteredArray : [Int] = []
    
    for money in moneyArray {
        if (money > 30) {
            filteredArray += [money]
        }
    }
    
    return filteredArray
}

filter(moneyArray: intArray)
//: [Next](@next)
