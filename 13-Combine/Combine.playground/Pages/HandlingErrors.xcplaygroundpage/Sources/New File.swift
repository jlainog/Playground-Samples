import Foundation

extension Notification.Name {
   public static let newTrick = Notification.Name("NewTrick")
}

public struct MagicTrick: Codable {
    public static var placeHolder = MagicTrick(name: "default", kind: "default")
    
    public var name: String
    public var kind: String
}

//
//  JSONSerializationDecoder.swift
//  Codable-Utils
//
//  Created by Jaime Andres Laino Guerra on 8/11/19.
//  Copyright © 2019 jaime Laino Guerra. All rights reserved.
//

import Combine

public struct JSONSerializationDecoder: TopLevelDecoder {
    public typealias Input = [AnyHashable: Any]
    public let decoder: JSONDecoder
    
    public init(decoder: JSONDecoder = .init()) {
        self.decoder = decoder
    }
    
    /// Decodes a top-level value of the given type from the given JSON Foundation representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter input: The foundation object to decode from.
    /// - returns: A value of the requested type.
    /// - throws: An error if any value throws an error during decoding.
    public func decode<T>(_ type: T.Type, from input: [AnyHashable : Any]) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: input, options: .prettyPrinted)
        return try decoder.decode(type, from: data)
    }
}

