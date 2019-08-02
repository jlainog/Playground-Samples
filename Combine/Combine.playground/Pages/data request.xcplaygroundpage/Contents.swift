//: [Previous](@previous)

import UIKit
import Combine
import PlaygroundSupport

extension URLSession {
    func data(with request: URLRequest) -> AnyPublisher<(Data, URLResponse), Error> {
        return AnyPublisher<(Data, URLResponse), Error> { subscriber in
            let task = self.dataTask(with: request) { data, response, error in
                guard let data = data, let response = response else {
                    subscriber.receive(completion: .failure(error!))
                    return
                }
                
                _ = subscriber.receive((data, response))
                subscriber.receive(completion: .finished)
            }
            task.resume()
        }
    }
}

let request = URLRequest(url: URL(string: "https://itunes.apple.com/lookup?id=909253")!)
URLSession.shared.data(with: request)
    .map { $0.0 }
    .decode(type: ArtistResponse.self, decoder: JSONDecoder())
    .sink { response in
        print(response)
        PlaygroundPage.current.finishExecution()
}

PlaygroundPage.current.needsIndefiniteExecution = true
//: [Next](@next)
