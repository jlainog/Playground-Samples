//: [Previous](@previous)

import Foundation

//: Codable

typealias Codable = Encodable & Decodable

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


//: [Next](@next)
