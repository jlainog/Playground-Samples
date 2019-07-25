import UIKit

//: Codable

typealias Codable = Encodable & Decodable

struct Article: Codable {
    let user: String
    let comments: String
    let visible: Bool
    let otherUser: String
    
    static var mock: Article = .init(user: "Jaime Laino",
                                     comments: "- New Comment",
                                     visible: false,
                                     otherUser: "Andres Guerra")
}

extension Data {
    func toString() -> String { String(decoding: self, as: UTF8.self) }
}

extension String {
    func print() { Swift.print(self) }
}

public protocol AnyTopLevelEncoder {
    associatedtype Output

    func encode<T>(_ value: T) throws -> Self.Output where T : Encodable
}

extension JSONEncoder: AnyTopLevelEncoder {}
extension PropertyListEncoder: AnyTopLevelEncoder {}

struct JSONStringEncoder: AnyTopLevelEncoder {
    typealias Output = String
    
    let encoder: JSONEncoder = JSONEncoder()
    
    func encode<T>(_ value: T) throws -> String where T : Encodable {
        let data = try encoder.encode(value)
        return String(decoding: data, as: UTF8.self)
    }
}

struct JSONSerializationEncoder: AnyTopLevelEncoder {
    typealias Output = [AnyHashable: Any]
    
    let encoder: JSONEncoder = JSONEncoder()
    
    func encode<T>(_ value: T) throws -> [AnyHashable : Any] where T : Encodable {
        let data = try encoder.encode(value)
        let serialization = try JSONSerialization.jsonObject(with: data,
                                                             options: .fragmentsAllowed)
        guard let output = serialization as? [AnyHashable: Any] else {
            throw EncodingError.invalidValue(value, .init(codingPath: [],
                                                          debugDescription: "Can't Turn into Dictionary"))
        }
        return output
    }
}

public extension Encodable {
    func encode() throws -> Data {
        try encode(using: JSONEncoder())
    }
    
    func encode<Encoder: AnyTopLevelEncoder>(using encoder: Encoder) throws -> Encoder.Output {
        try encoder.encode(self)
    }
    
    func encodeJSON() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.keyEncodingStrategy = .useDefaultKeys
        return try encoder.encode(self)
    }
    
    func encodePropertyList() throws -> Data {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        return try encoder.encode(self)
    }
}

let xmlPropertyList = PropertyListEncoder()
xmlPropertyList.outputFormat = .xml

let jsonEncoder = JSONEncoder()
jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
jsonEncoder.keyEncodingStrategy = .useDefaultKeys

try Article.mock.encode(using: jsonEncoder).toString()
try Article.mock.encode(using: JSONStringEncoder())
try Article.mock.encode(using: JSONSerializationEncoder())
try Article.mock.encode(using: xmlPropertyList).toString()


public extension Decodable {
    static func decode(from data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }
    static func decode(from string: String) throws -> Self {
        let data = string.data(using: .utf8)!
        return try decode(from: data)
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

try Article.decode(from: jsonString)


try Article
    .mock
    .encodeJSON()
    .toString()
    .print()

try Article
    .mock
    .encodePropertyList()
    .toString()
    .print()

//try Article.mock
//.jsonEncoder()
//.encode()
//.toDictionary()
