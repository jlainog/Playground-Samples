//: [Previous](@previous)

import UIKit
import Combine
import PlaygroundSupport

let url = URL(string: "https://itunes.apple.com/lookup?id=909253")!

URLSession.shared.dataTaskPublisher(for: url)
    .map { $0.0 }
    .decode(type: ArtistResponse.self, decoder: JSONDecoder())
    .sink(receiveCompletion: { (completion) in
        switch completion {
        case .failure(let error):
            assertionFailure(error.localizedDescription)
        case .finished:
            print("all good")
        }
    }, receiveValue: { response in
        print(response)
        PlaygroundPage.current.finishExecution()
    })

PlaygroundPage.current.needsIndefiniteExecution = true
//: [Next](@next)
