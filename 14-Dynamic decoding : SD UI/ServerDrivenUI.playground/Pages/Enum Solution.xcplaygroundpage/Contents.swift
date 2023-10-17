//: [Previous](@previous)

import Foundation
import UIKit
import SwiftUI

let json = """
[
  {
    "text" : "Some Text",
    "type" : "MESSAGE"
  },
  {
    "title" : "Button Title",
    "type" : "BUTTON"
  }
]
"""

struct MessageRow: Codable {
    var text: String
}

struct ButtonRow: Codable {
    var title: String
}

enum Row {
    case message(MessageRow)
    case button(ButtonRow)
//    case newMessage(MessageRow)
}

extension Row {
    enum `Type`: String, Codable {
        case message = "MESSAGE"
        case button = "BUTTON"
    }
    
    var type: `Type` {
        switch self {
        case .message: return .message
        case .button: return .button
        }
    }
}

private enum CodingKeys: String, CodingKey {
    case type
}

extension Row: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(`Type`.self, forKey: .type)

        switch type {
        case .message: self = .message(try .init(from: decoder))
        case .button: self = .button(try .init(from: decoder))
        }
    }
}

extension Row: Encodable {
    public func encode(to encoder: Encoder) throws {
        var singleValueContainer = encoder.singleValueContainer()

        switch self {
        case .message(let row): try singleValueContainer.encode(row)
        case .button(let row): try singleValueContainer.encode(row)
        }

        // NOTE this needs to be called *after* encoding into the singleValueContainer
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
    }
}

let decodedJson = try JSONDecoder().decode([Row].self, from: json.data(using: .utf8)!)
let encodedJson = try JSONEncoder().encode(decodedJson)
let jsonObject = try JSONSerialization.jsonObject(with: encodedJson, options: [])
let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys])
let prettyPrintedJson = String(data: data, encoding: .utf8)!
//print(prettyPrintedJson)
assert(prettyPrintedJson == json)

extension Row /*: Renderable*/ {
    func render(inParent parent: UIViewController? = nil) -> UIView {
        switch self {
        case .message(let row):
            let viewController = UIHostingController(rootView: Text(row.text))
            viewController.view.backgroundColor = .clear
            return viewController.view
        case .button(let row):
            let viewController = UIHostingController(rootView: Button(row.title, action: {}))
            viewController.view.backgroundColor = .clear
            return viewController.view
        }
    }
}

import PlaygroundSupport

let stack = UIStackView()
stack.distribution = .fillProportionally
stack.axis = .vertical
decodedJson.forEach { row in
    let view = row.render()
    stack.addArrangedSubview(view)
}

struct ViewRepresentable: UIViewRepresentable {
    let _makeUIView: () -> UIView

    func makeUIView(context: Context) -> some UIView {
        _makeUIView()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

PlaygroundPage.current.setLiveView(
    ViewRepresentable { stack }
)


//: [Next](@next)

let body = [
    Row.message(.init(text: "")),
    Row.button(.init(title: "")),
]

//Body {
//    MessageRow(text: "")
//    ButtonRow(title: "")
//}
