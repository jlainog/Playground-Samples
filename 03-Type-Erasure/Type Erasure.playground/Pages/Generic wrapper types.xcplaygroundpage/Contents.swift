//: [Previous](@previous)

import Foundation

//: # Generic wrapper types

protocol Request {
    associatedtype Response
    associatedtype Error: Swift.Error
    
    typealias Handler = (Result<Response, Error>) -> Void
    
    func perform(then handler: @escaping Handler)
}

struct AnyRequest<Response, Error: Swift.Error> {
    typealias Handler = (Result<Response, Error>) -> Void
    
    let perform: (@escaping Handler) -> Void
    let handler: Handler
}

class RequestQueue<Response, Error: Swift.Error> {
    private typealias TypeErasedRequest = AnyRequest<Response, Error>
    
    private var queue = [TypeErasedRequest]()
    private var ongoing: TypeErasedRequest?
    
    // We modify our 'add' method to include a 'where' clause that
    // gives us a guarantee that the passed request's associated
    // types match our queue's generic types.
    func add<R: Request>(
        _ request: R,
        handler: @escaping R.Handler
        ) where R.Response == Response, R.Error == Error {
        // To perform our type erasure, we simply create an instance
        // of 'AnyRequest' and pass it the underlying request's
        // 'perform' method as a closure, along with the handler.
        let typeErased = AnyRequest(
            perform: request.perform,
            handler: handler
        )
        
        // Since we're implementing a queue, we don't want to perform
        // two requests at once, but rather save the request for
        // later in case there's already an ongoing one.
        guard ongoing == nil else {
            queue.append(typeErased)
            return
        }
        
        perform(typeErased)
    }
    
    private func perform(_ request: TypeErasedRequest) {
        ongoing = request
        
        request.perform { [weak self] result in
            request.handler(result)
            self?.ongoing = nil
            
            // Perform the next request if the queue isn't empty
        }
    }
}
//: [Next](@next)
