//: [Previous](@previous)

/*:
 # .flatMap
 */
let intArrays = [[10, 30], [40, 20], [45, 32]]
let f = { (array: [Int]) in array.map { "\($0)$" } }
intArrays.flatMap(f)

func flatMap(moneyArrays: [[Int]]) -> [String] {
    var stringsArray : [String] = []

    for innerArray in moneyArrays {
        for money in innerArray {
            stringsArray.append("\(money)$")
        }
    }

    return stringsArray
}

flatMap(moneyArrays: intArrays)

func flatMap<A,B>(transform: @escaping ([A]) -> [B]) -> ([[A]]) -> [B] {
    return { array in
        var result = [B]()

        for innerArray in array {
            let transformedArray = transform(innerArray)
            result.append(contentsOf: transformedArray)
        }

        return result
    }
}

flatMap(transform: f)(intArrays)
//: [Next](@next)
