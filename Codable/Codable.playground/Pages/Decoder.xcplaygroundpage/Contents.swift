//: [Previous](@previous)

import Foundation

public protocol AnyTopLevelDecoder {
    associatedtype Input

    func decode<T>(_ type: T.Type, from: Self.Input) throws -> T where T : Decodable
}
extension JSONDecoder: AnyTopLevelDecoder {}

struct JSONStringDecoder: AnyTopLevelDecoder {
    typealias Input = String
    let decoder: JSONDecoder = .init()
    
    func decode<T>(_ type: T.Type, from input: String) throws -> T where T : Decodable {
        let data = input.data(using: .utf8)!
        return try decoder.decode(type, from: data)
    }
}

public extension Decodable {
    static func decode(from input: Data) throws -> Self {
        try decode(from: input, using: JSONDecoder())
    }
    
    static func decode<Decoder: AnyTopLevelDecoder>(from input: Decoder.Input,
                                                    using decoder: Decoder) throws -> Self {
       try decoder.decode(Self.self, from: input)
    }
}

let jsonString =
"""
{
  "comments" : "- New Comment",
  "otherUser" : "Andres Guerra",
  "user" : "Jaime Laino",
  "visible" : false
}
"""

try Article.decode(from: jsonString, using: JSONStringDecoder())

//: [Next](@next)
