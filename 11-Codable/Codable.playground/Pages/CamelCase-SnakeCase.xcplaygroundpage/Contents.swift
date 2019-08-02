//: [Previous](@previous)

import Foundation

struct ReadMe: Codable {
    var title: String
    var content: String
}
struct PlaygroundPage: Codable {
    var code: String
}
struct Playground: Codable {
    var pages: [PlaygroundPage]
}
struct PlaygroundSample: Codable {
    var name: String
    var readMe: ReadMe
    var playground: Playground
}
let readme = ReadMe(title: "Codable", content: "Example of nested types using codable")
let page = PlaygroundPage(code: "encode(self) - decode(self)")
let playgroundSample = PlaygroundSample(name: "Codable",
                                        readMe: readme,
                                        playground: .init(pages: [page]))

let jsonEncoder = JSONEncoder()
jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
jsonEncoder.keyEncodingStrategy = .useDefaultKeys

let jsonDecoder = JSONDecoder()
jsonDecoder.keyDecodingStrategy = .useDefaultKeys

//: Nested Types
try playgroundSample.encode(using: jsonEncoder).toString().print()

//: Snake_Case
jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
let snakeData = try playgroundSample.encode(using: jsonEncoder)
snakeData.toString().print()

jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
try PlaygroundSample.decode(from: snakeData, using: jsonDecoder)



//: [Next](@next)
