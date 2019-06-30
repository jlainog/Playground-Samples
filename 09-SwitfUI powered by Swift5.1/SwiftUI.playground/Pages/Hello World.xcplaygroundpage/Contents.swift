







//: [Previous](@previous)

import SwiftUI
import PlaygroundSupport

struct Options {
    var quantity: Int = 5
    var toggle: Bool = true
}

struct SomeVStack: View {
    /// Property Wrappers SE-0258
    @State private var options = Options()
    
    /// Opaque results types SE-0244
    var body: some View {
        /// Implicit Returns SE-0255

        /// ViewBuilder https://developer.apple.com/documentation/swiftui/viewbuilder
        /// function-builders https://forums.swift.org/t/function-builders/25167
        VStack {
            Text("My Title").font(.title)
            
            Toggle(isOn: $options.toggle) {
                Text("Should Toggle?")
            }
            
            Text("Want more?")
            
            /// Dynamic member lookups  SE-0195
            Stepper(value: $options.quantity, in: 1...10) {
                Text("How Much? \(options.quantity)")
            }
        }
    }
}

struct helloWorldView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            Text("Hello World").font(.title)
            Spacer()
            Text("Hola mundo").font(.title)
        }).padding([.leading, .trailing], 20)
    }
}

struct ContentView : View {
    var body: some View {
        VStack {
            Divider()
            helloWorldView()
            Divider()
            SomeVStack()
            Divider()
        }
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = UIHostingController(rootView: ContentView())

//: [Next](@next)
