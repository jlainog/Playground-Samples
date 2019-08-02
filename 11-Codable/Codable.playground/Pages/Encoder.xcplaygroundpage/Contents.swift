//: [Previous](@previous)

import Foundation

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
}

let xmlPropertyList = PropertyListEncoder()
xmlPropertyList.outputFormat = .xml

let jsonEncoder = JSONEncoder()
jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
jsonEncoder.keyEncodingStrategy = .useDefaultKeys

try Article.mock.encode(using: jsonEncoder).toString().print()
try Article.mock.encode(using: xmlPropertyList).toString().print()
try Article.mock.encode(using: JSONStringEncoder()).print()
try Article.mock.encode(using: JSONSerializationEncoder())
//: [Next](@next)
