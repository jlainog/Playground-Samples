//: [Previous](@previous)

import Foundation

enum UIElement {
    case label(UIElement.Label)
    case vStack(UIElement.VStack)
    case hStack(UIElement.HStack)
    case sfSymbol(UIElement.SFSymbol)
}

extension UIElement {
    struct Label: Decodable {
        var text: String
    }

    struct VStack: Decodable {
        var content: [UIElement]
    }

    struct HStack: Decodable {
        var content: [UIElement]
    }

    struct SFSymbol: Decodable {
        var name: String
    }
}

let jsonString = """
{
    "type": "vstack",
    "content": [
        {
            "type": "hstack",
            "content": [
                {
                    "type": "sfsymbol",
                    "name": "pencil"
                },
                {
                    "type": "label",
                    "text": "example"
                }
            ]
        },
        {
            "type": "label",
            "text": "second line"
        }
    ]
}
"""

extension UIElement: Decodable {
    enum CodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let type = try container.decode(UIElementType.self, forKey: .type)

        switch type {
        case .label:
            self = .label(try UIElement.Label(from: decoder))
        case .hstack:
            self = .hStack(try UIElement.HStack(from: decoder))
        case .vstack:
            self = .vStack(try UIElement.VStack(from: decoder))
        case .sfsymbol:
            self = .sfSymbol(try UIElement.SFSymbol(from: decoder))
        }
    }

    enum UIElementType: String, Codable {
        case label
        case hstack
        case vstack
        case sfsymbol
    }

    var uiElementType: UIElementType {
        switch self {
        case .label: return .label
        case .hStack: return .hstack
        case .vStack: return .vstack
        case .sfSymbol: return .sfsymbol
        }
    }
}

let jsonDecoder = JSONDecoder()
var uiElement = try jsonDecoder.decode(
    UIElement.self,
    from: jsonString.data(using: .utf8)!
)

//: [Next](@next)

