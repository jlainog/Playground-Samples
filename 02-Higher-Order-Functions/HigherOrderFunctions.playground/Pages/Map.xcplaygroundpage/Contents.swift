//: [Previous](@previous)
/*:
 # .map(f)
 */
let mapArray = [10,20,45,32]
let f = { (value: Int) in "\(value)$" }
let map = mapArray.map(f)

mapArray.flatMap(f)

func addDollarSign(array: [Int]) -> [String] {
    var stringsArray : [String] = []
    
    for money in array {
        stringsArray.append("\(money)$")
    }
    
    return stringsArray
}

addDollarSign(array: mapArray)
//: [Next](@next)

