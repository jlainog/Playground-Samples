//: [Previous](@previous)

import Foundation
import SwiftUI

@discardableResult
func testEncodable<T: Encodable>(_ value: T) throws -> String {
    let encodedJson = try JSONEncoder().encode(value)
    let encodedJsonObject = try JSONSerialization.jsonObject(with: encodedJson, options: [])
    let data = try JSONSerialization.data(withJSONObject: encodedJsonObject, options: [.prettyPrinted, .sortedKeys])
    let prettyPrintedJson = String(data: data, encoding: .utf8)!
    print("\n/////////////")
    print(prettyPrintedJson)
    print("/////////////\n")
    return prettyPrintedJson
}

func testCodable<T: Codable>(json: String, type: T.Type) throws {
    let decodedJson = try JSONDecoder().decode(T.self, from: json.data(using: .utf8)!)
    let resultJson = try testEncodable(decodedJson)
    assert(resultJson == json)
}

// MARK: Row
protocol Row {}

struct MessageRow: Row, Codable {
    var text: String
}
struct ButtonRow: Row, Codable {
    var title: String
}
struct NewMessageRow: Row, Codable {
    var message: String
}
struct DividerRow: Row, Codable {}
struct SectionRow: Row, Codable {
    let body: Body

    init(@BodyBuilder build: () -> [Row]) {
        self.body = .init(build: build)
    }
}

// MARK: CodableRow
struct CodableRow: Codable {
    private typealias _CodableRow = Codable & Row
    
    private static let register: [String: _CodableRow.Type] = [
        "BUTTON": ButtonRow.self,
        "MESSAGE": MessageRow.self,
        "NEW_MESSAGE": NewMessageRow.self,
        "SECTION": SectionRow.self,
        "DIVIDER": DividerRow.self
    ]
    
    enum CodingKeys: String, CodingKey {
        case type
    }
    
    private let _row: _CodableRow
    var row: Row { _row }
    
    init(_ row: Row) throws {
        guard let row = row as? _CodableRow else {
            throw EncodingError.invalidValue(
                row, .init(
                    codingPath: [],
                    debugDescription: "\(type(of: row)) is not encodable."
                )
            )
        }
        self._row = row
    }
    
    init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        let rowType = try keyedContainer.decode(String.self, forKey: .type)
        
        guard let decodableType = Self.register[rowType] else {
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: keyedContainer,
                debugDescription: "\(rowType) is not decodable."
            )
        }
        
        let singleValueContainer = try decoder.singleValueContainer()
        self._row = try singleValueContainer.decode(decodableType) as _CodableRow
    }
    
    func encode(to encoder: Encoder) throws {
        var singleValueContainer = encoder.singleValueContainer()
        
        guard let type = Self.register.first(where: { $1 == type(of: _row) })?.key else {
            throw EncodingError.invalidValue(
                _row, .init(
                    codingPath: singleValueContainer.codingPath,
                    debugDescription: "\(type(of: _row)) is not registered."
                )
            )
        }

        try singleValueContainer.encode(_row)

        var keyedContainer = encoder.container(keyedBy: CodingKeys.self)
        try keyedContainer.encode(type, forKey: .type)
    }
}

try testCodable(
    json: """
{
  "text" : "Some Text",
  "type" : "MESSAGE"
}
""",
    type: CodableRow.self
)

// MARK: Body
struct Body {
    var rows: [Row] = []
}

extension Body: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.rows = []
        
        while !container.isAtEnd {
            let superDecoder = try container.superDecoder()
            self.rows.append(
                try CodableRow(from: superDecoder).row
            )
        }
    }
}

extension Body: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()

        for row in rows {
            let superEncoder = container.superEncoder()
            try CodableRow(row).encode(to: superEncoder)
        }
    }
}

try testCodable(
    json: """
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
""",
    type: Body.self
)

// MARK: BodyBuilder
@resultBuilder
struct BodyBuilder {
//    static func buildBlock(_ components: Row...) -> [Row] {
//        Array(components)
//    }
    
    static func buildBlock() -> [Row] { [] }

    static func buildEither(first component: [Row]) -> [Row] { component }
    static func buildEither(second component: [Row]) -> [Row] { component }

    static func buildOptional(_ component: [Row]?) -> [Row] { component ?? [] }
   
    // https://forums.swift.org/t/pitch-buildpartialblock-for-result-builders/55561
    static func buildPartialBlock(first: Never) -> [Row] {}
    static func buildPartialBlock(first: Row) -> [Row] { [first] }
    static func buildPartialBlock(first: [Row]) -> [Row] { first }
    static func buildPartialBlock(accumulated: [Row], next: Row) -> [Row] { accumulated + [next] }
    static func buildPartialBlock(accumulated: [Row], next: [Row]) -> [Row] { accumulated + next }
    static func buildPartialBlock(accumulated: [Row], next: Row?) -> [Row] { next.flatMap { accumulated + [$0] } ?? accumulated }
}

extension Body {
    init(@BodyBuilder build: () -> [Row]) {
        self.rows = build()
    }
}

let body = Body {
    MessageRow(text: "Some Text")
    DividerRow()
    ButtonRow(title: "Button Title")
    DividerRow()
    NewMessageRow(message: "Example")

    if true {
        DividerRow()
    }
    
    SectionRow {
        MessageRow(text: "some Title")
        ButtonRow(title: "Button Title")
    }

    Optional<Row>.some(DividerRow())

    SectionRow {
        ButtonRow(title: "Button Title")
        NewMessageRow(message: "Example")
    }

//    LinearButton(text: "example", title: "buton title")
}

do {
    try testEncodable(body)
} catch {
    dump(error)
}

import PlaygroundSupport

protocol Renderable {
    func render(with parent: UIViewController?) -> UIView
}

extension MessageRow: Renderable {
    func render(with parent: UIViewController? = nil) -> UIView {
        let viewController = UIHostingController(rootView: Text(self.text))
        viewController.view.backgroundColor = .clear
        return viewController.view
    }
}
extension ButtonRow: Renderable {
    func render(with parent: UIViewController? = nil) -> UIView {
        let viewController = UIHostingController(rootView: Button(self.title, action: {}))
        viewController.view.backgroundColor = .clear
        return viewController.view
    }
}
extension NewMessageRow: Renderable {
    func render(with parent: UIViewController? = nil) -> UIView {
        let viewController = UIHostingController(rootView: Text(self.message))
        viewController.view.backgroundColor = .clear
        return viewController.view
    }
}
extension DividerRow: Renderable {
    func render(with parent: UIViewController?) -> UIView {
        let viewController = UIHostingController(rootView: Divider())
        viewController.view.backgroundColor = .clear
        return viewController.view
    }
}
extension SectionRow: Renderable {
    func render(with parent: UIViewController?) -> UIView {
        body.render(with: parent)
    }
}

struct LinearButton: Row, Renderable {
    var text: String
    var title: String
    
    func render(with parent: UIViewController?) -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        
        Body {
            MessageRow(text: text)
            DividerRow()
            ButtonRow(title: title)
        }
        .rows
        .compactMap { $0 as? Renderable }
        .map { $0.render(with: parent) }
        .forEach(stack.addArrangedSubview)
        return stack
    }
}

struct CustomRow: Row {
    var idenfier: String
    var build: (_ parent: UIViewController?) -> UIView
}

extension CustomRow: Renderable {
    func render(with parent: UIViewController?) -> UIView {
        build(parent)
    }
}

extension Body: Renderable {
    func render(with parent: UIViewController?) -> UIView {
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        rows.forEach { row in
            guard let row = row as? Renderable else { return }
            let view = row.render(with: parent)
            stack.addArrangedSubview(view)
        }
        return stack
    }
}

struct ViewRepresentable: UIViewRepresentable {
    let _makeUIView: () -> UIView

    func makeUIView(context: Context) -> some UIView {
        _makeUIView()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

PlaygroundPage.current.setLiveView(
    ViewRepresentable { body.render(with: nil) }
)

//: [Next](@next)
