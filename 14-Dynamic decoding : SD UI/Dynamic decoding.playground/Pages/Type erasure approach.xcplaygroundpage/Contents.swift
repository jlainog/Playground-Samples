//: [Previous](@previous)

import Foundation

protocol UIElement: Decodable {}

struct Label: UIElement {
    var text: String
}

struct VStack: UIElement, Decodable {
    var content: [AnyUIElement]
}

struct HStack: UIElement {
    var content: [AnyUIElement]
}

struct SFSymbol: UIElement {
    var name: String
}

struct AnyUIElement: UIElement {
    enum CodingKeys: String, CodingKey {
        case type
    }

    var uiEement: UIElement

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeName = try container.decode(String.self, forKey: .type)

//        let mangledTypeName = _mangledTypeName(HStack.self)!
//        print(mangledTypeName)
//        print(_typeByName(mangledTypeName))

//        guard let type = _typeByName(typeName) as? any Decodable.Type else {
        guard let type = registry[typeName] else {
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "\(typeName) is not decodable."
            )
        }

        guard let uiElement = try type.init(from: decoder) as? UIElement else {
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "\(typeName) is not UIElement."
            )
        }

        self.uiEement = uiElement
    }
}

var registry: [String: any Decodable.Type] = [
    "HStack": HStack.self,
    "VStack": VStack.self,
    "Label": Label.self,
    "SFSymbol": SFSymbol.self
]

let jsonString = """
{
    "type": "VStack",
    "content": [
        {
            "type": "HStack",
            "content": [
                {
                    "type": "SFSymbol",
                    "name": "pencil"
                },
                {
                    "type": "Label",
                    "text": "example"
                }
            ]
        },
        {
            "type": "Label",
            "text": "second line"
        }
    ]
}
"""

let jsonDecoder = JSONDecoder()
var uiElement = try jsonDecoder.decode(
    AnyUIElement.self,
    from: jsonString.data(using: .utf8)!
)

//protocol AnyDecodable: Decodable {}
//
//enum CodingKeys: String, CodingKey {
//    case type
//}
//
//extension AnyDecodable {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let typeName = try container.decode(String.self, forKey: .type)
//        print(typeName)
//        throw NSError(domain: "", code: 0)
//    }
//}
//
//var decodedAnyUIElement = try JSONDecoder().decode(
//    AnyDecodable.self,
//    from: #"{"type": "Text"}"#.data(using: .utf8)!
//)


//: [Next](@next)
