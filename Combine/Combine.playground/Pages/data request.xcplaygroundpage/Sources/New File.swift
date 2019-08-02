import Foundation

public extension String.StringInterpolation {
    mutating func appendInterpolation<T: Encodable>(debug value: T) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let result = try! encoder.encode(value)
        let str = String(decoding: result, as: UTF8.self)
        appendLiteral(str)
    }
}

extension CustomStringConvertible where Self: Codable  {
    public var description: String { "\(debug: self)" }
}

public struct Artist: Codable, CustomStringConvertible {
    var wrapperType: String
    var artistType: String
    var artistName: String
    var artistLinkUrl: String
    var artistId: Int
    var amgArtistId: Int
    var primaryGenreName: String
    var primaryGenreId: Int
}

public struct ArtistResponse: Codable, CustomStringConvertible {
    var resultCount: Int
    var results: [Artist]
}


