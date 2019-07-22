//: [Previous](@previous)

import Foundation

class BaseClass: Codable {
    var id: Int
    
    init(id: Int) {
        self.id = id
    }
}

class ConcreteClass: BaseClass {
    var name: String
    
    init(name: String, id: Int) {
        self.name = name
        super.init(id: id)
    }
    
    enum CodingKeys: CodingKey {
        case name, baseClass
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        
//        try super.init(from: decoder)
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        
//        try super.encode(to: encoder)
        try super.encode(to: container.superEncoder())
    }
}

let jsonString =
"""
{
    "id": 20,
    "name": "Jaime"
}
"""

let jsonStringWithSuper =
"""
{
    "super": {
        "id": 20
    },
    "name": "Jaime"
}
"""
extension ConcreteClass: CustomDebugStringConvertible {}

try ConcreteClass
    .decode(from: jsonStringWithSuper, using: JSONStringDecoder())
    .debugDescription
    .print()


//: [Next](@next)
