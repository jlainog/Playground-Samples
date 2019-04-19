//: [Previous](@previous)
/*:
 # .compactMap
 */
let intArray = [10, nil, 20, nil, 45, 32, nil]
let f = { (value: Int?) in value != nil ? "\(value!)$" : nil }
intArray.compactMap(f)

func compactMap(moneyArray: [Int?]) -> [String] {
    var stringsArray : [String] = []
    
    for money in moneyArray where money != nil {
        stringsArray.append("\(money!)$")
    }
    
    return stringsArray
}

compactMap(moneyArray: intArray)

//: [Next](@next)
