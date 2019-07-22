import Foundation

public struct Article: Codable {
    public let user: String
    public let comments: String
    public let visible: Bool
    public let otherUser: String
    
    public static var mock: Article = .init(user: "Jaime Laino",
                                            comments: "- New Comment",
                                            visible: false,
                                            otherUser: "Andres Guerra")
}

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
        try encode(using: JSONEncoder())
    }
    
    func encode<Encoder: AnyTopLevelEncoder>(using encoder: Encoder) throws -> Encoder.Output {
        try encoder.encode(self)
    }
}
