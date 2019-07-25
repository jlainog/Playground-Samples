//: [Previous](@previous)

import CoreLocation

struct Coordinate {
    var latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}

extension Coordinate: Codable {
    // CodingKeys
    enum CodingKeys: String, CodingKey {
        // Custom Coding Keys
        case latitude = "lat-itude"
        case longitude
    }

    public func encode(to encoder: Encoder) throws {
        // Container keyedBy:
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
    }
}

let coordinate = Coordinate(latitude: 0.12, longitude: 12.5)
try coordinate.encode().toString().print()



//: [Next](@next)
