//: [Previous](@previous)

import SwiftUI
import PlaygroundSupport

struct MovieRow: View {
    var name: String
    
    var body: some View {
        Text(name)
    }
}

struct ContentView: View {
    var body: some View {
        List {
            MovieRow(name: "Godzilla")
            MovieRow(name: "Detective Pickachu")
            MovieRow(name: "Aladdin")
            MovieRow(name: "End Game")
        }
    }
}

PlaygroundPage.current.liveView = UIHostingController(rootView: ContentView())

//: [Next](@next)
