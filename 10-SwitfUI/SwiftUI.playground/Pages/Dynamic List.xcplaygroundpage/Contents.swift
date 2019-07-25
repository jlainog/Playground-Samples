//: [Previous](@previous)

import SwiftUI
import PlaygroundSupport

struct Movie: Identifiable {
    let id = UUID.init()
    var name: String
}

struct MovieRow: View {
    var movie: Movie
    
    var body: some View {
        Text(movie.name)
    }
}

struct Options {
    var quantity: Int
    var toggle: Bool
}

struct SomeVStack: View {
    @State private var options: Options = Options(quantity: 5,
                                                  toggle: true)
    
    var body: some View {
        VStack {
            Text("My Title").font(.title)
            
            Toggle(isOn: $options.toggle) {
                Text("Should Toggle?")
            }
            
            Text("Want more?")
            Stepper(value: $options.quantity, in: 1...10) {
                Text("How Much? \(options.quantity)")
            }
        }
    }
}

struct ContentView: View {
    var movies: [Movie]
    
    var body: some View {
//        List(movies, rowContent: MovieRow.init(movie: ))
        List {
            Section(header: Text("SomeVStack"),
                    footer: Text("SomeVStack"),
                    content: SomeVStack.init)
            Section(header: Text("Header Movies"),
                    footer: Text("Footer Movies"))
            {
                ForEach(movies, content: MovieRow.init(movie: ))
            }
            Section(header: Text("Header 0")
                .font(.largeTitle),
                    footer: Text("Footer 0")
                        .font(.title))
            {
                Text("Content").font(.headline)
                Text("Content").font(.body)
                Text("Content").font(.callout)
                Text("Content").font(.footnote)
                Text("Content").font(.caption)
            }

            Section(header: Text("Header 1"),
                    footer: Text("Footer 1"))
            {
                Text("Content")
                Text("Content")
                Text("Content")
                Text("Content")
                Text("Content")
            }
        }
    }
}

var movies = ["a", "b", "c"].map(Movie.init)
let contentView = ContentView(movies: movies)

PlaygroundPage.current.liveView = UIHostingController(rootView: contentView)

//: [Next](@next)
