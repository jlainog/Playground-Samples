//: [Previous](@previous)
/*:
 # Using HighOrder Functions
 */
let squaresPairs = (1..<10)
    .map { $0 * $0 }
    .filter { $0 % 2 == 0 }
squaresPairs
let contains = squaresPairs.contains(where: { Int(Double($0) / 2.0) % 2 == 0 })
contains
let text = [1,2,3,4].reduce("") { str, num in str + "\(num)\n" }
text
//: # Defining Custom High Order Functions

extension Sequence {
    func jaimeMap<U>( _ transform: (Self.Iterator.Element) -> U) -> [U] {
        var result = [U]()
        
        result.reserveCapacity(self.underestimatedCount)
        
        for x in self {
            let transformedValue = transform(x)
            
            result.append(transformedValue)
        }
        
        return result
    }
    
    func allMatch(_ comparison: (Self.Iterator.Element) -> Bool) -> Bool {
//        var allMatch = true
//        
//        for x in self where !comparison(x) {
//            allMatch = false
//            break
//        }
//        
//        return allMatch
        return !contains { !comparison($0) }
    }
    
    func noneMatch(_ comparison: (Self.Iterator.Element) -> Bool) -> Bool {
        return !allMatch(comparison)
    }
    
    func count(_ comparison: (Self.Iterator.Element) -> Bool) -> Int {
        var count = 0
        
        for x in self where comparison(x) {
            count+=1
        }
        
        return count
    }
    
    func indicesOf(_ comparison: (Self.Iterator.Element) -> Bool) -> [Int] {
        var indices = [Int]()
        
        for (index, x) in self.enumerated() where comparison(x) {
            indices.append(index)
        }
        
        return indices
    }
    
    func findElement(match: (Self.Iterator.Element) -> Bool) -> Self.Iterator.Element? {
        for element in self where match(element) {
            return element
        }
        
        return nil
    }
    
    func accumulate<U>(_ initial: U, combine: (U, Self.Iterator.Element) -> U) -> [U] {
        var running = initial
        
        return self.map {
            next in
            running = combine(running, next)
            return running
        }
    }
}

//: # Example
let cast = ["Vivien", "Marlon", "Kim", "Karl"]
let countedCharacters = cast.jaimeMap { $0.count }
countedCharacters

let allMatch = cast.allMatch { $0.count >= 3 }
allMatch

let noneMatch = cast.noneMatch { $0.count >= 3 }
noneMatch

let countMatch = cast.count { $0.count <= 4 }
countMatch

let indicesOf = cast.indicesOf { $0.count <= 4 }
indicesOf

let element =  cast.findElement(match: { $0.count == 4 })
element

let accumulate = cast.accumulate(0) { (accumulate, next) -> Int in
    return accumulate + next.count
}
accumulate

let accum = [1,2,3,4].accumulate(0, combine: +)
accum

//: [Next](@next)
