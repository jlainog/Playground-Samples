







//: [Previous](@previous)

import SwiftUI

class AnalyticsBuilder {
    private var isLogged: Bool?
    private var action: String?
    private var state: String?
    
    func isLogged(_ value: Bool) -> AnalyticsBuilder {
        isLogged = value
        return self
    }
    func with(action: String) -> AnalyticsBuilder {
        self.action = action
        return self
    }
    func with(state: String) -> AnalyticsBuilder {
        self.state = state
        return self
    }
    
    func build() -> [String: Any?] {
        ["isLogged": isLogged,
         "action": action,
         "state": state]
    }
}

var params =
    AnalyticsBuilder()
    .with(action: "playground Trigger")
    .with(state: "current")
    .isLogged(false)
    .build()
params

//: [Function Builders](https://github.com/apple/swift-evolution/blob/9992cf3c11c2d5e0ea20bee98657d93902d5b174/proposals/XXXX-function-builders.md)

@_functionBuilder
struct StringBuilder {
    func build() -> String {
        "Some " +
        "Text " +
        "View"
    }
    
    static func buildBlock(_ children: String...) -> String {
        children.reduce("") { $0 + $1 }
    }
}

func body(@StringBuilder values: () -> String) -> String { values() }

var someBody = body {
    "Some "
    "Weird "
    "form "
    "to create a string"
}
someBody


//: [ViewBuilder](https://developer.apple.com/documentation/swiftui/viewbuilder)
func menuView<Items: View>(@ViewBuilder items: () -> Items) -> some View {
    items()
}

let view = menuView {
    Text("Hello, World!")
    Divider()
    Text("Hola Mundo!")
}

//import PlaygroundSupport
//PlaygroundPage.current.liveView = UIHostingController(rootView: view)

@_functionBuilder
struct AttributeStringBuilder {
    static func buildBlock(_ values: NSAttributedString...) -> NSAttributedString {
        values.reduce(NSMutableAttributedString()) { result, value in
            result.append(value)
            return result
        }
    }
}

func attributeSting(
    @AttributeStringBuilder
    values: () -> NSAttributedString
    ) -> NSAttributedString {
    values()
}

let attributeString = attributeSting {
    title("Hello, World!")
    newLine
    subtitle("A new World is Ahead")
}

//PlaygroundPage.current.liveView = buildLabel(text: attributeString)

//: [Next](@next)
