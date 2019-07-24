//: [Previous](@previous)

import SwiftUI
import PlaygroundSupport

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
    var namesContainer: some View {
        HStack {
            Text("Peter").font(.body)
            Spacer()
            Text("Pedro").font(.body)
            }.padding([.leading, .trailing], 20)
    }
    
    var body: some View {
        VStack {
            Divider()
            helloWorldView()
            Divider()
            namesContainer
            Divider()
        }
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = UIHostingController(rootView: ContentView())

//: [Next](@next)
