import Foundation

public extension Data {
    func toString() -> String { String(decoding: self, as: UTF8.self) }
}

public extension String {
    func print() { Swift.print(self) }
}

public protocol AnyTopLevelEncoder {
    associatedtype Output

    func encode<T>(_ value: T) throws -> Self.Output where T : Encodable
}

extension JSONEncoder: AnyTopLevelEncoder {}
extension PropertyListEncoder: AnyTopLevelEncoder {}

public struct JSONStringEncoder: AnyTopLevelEncoder {
    public typealias Output = String
    
    public let encoder: JSONEncoder = JSONEncoder()
    
    public func encode<T>(_ value: T) throws -> String where T : Encodable {
        let data = try encoder.encode(value)
        return String(decoding: data, as: UTF8.self)
    }
}

public struct JSONSerializationEncoder: AnyTopLevelEncoder {
    public typealias Output = [AnyHashable: Any]
    
    public let encoder: JSONEncoder = JSONEncoder()
    
    public func encode<T>(_ value: T) throws -> [AnyHashable : Any] where T : Encodable {
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
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encode(using: jsonEncoder)
    }
    
    func encode<Encoder: AnyTopLevelEncoder>(using encoder: Encoder) throws -> Encoder.Output {
        try encoder.encode(self)
    }
}

public protocol AnyTopLevelDecoder {
    associatedtype Input

    func decode<T>(_ type: T.Type, from: Self.Input) throws -> T where T : Decodable
}
extension JSONDecoder: AnyTopLevelDecoder {}

public struct JSONStringDecoder: AnyTopLevelDecoder {
    public typealias Input = String
    public let decoder: JSONDecoder = .init()
    
    public func decode<T>(_ type: T.Type, from input: String) throws -> T where T : Decodable {
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
