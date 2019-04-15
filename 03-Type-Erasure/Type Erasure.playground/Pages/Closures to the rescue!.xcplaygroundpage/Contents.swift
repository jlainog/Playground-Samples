//: [Previous](@previous)

import Foundation

//: # Using Closures

protocol Request {
    associatedtype Response
    associatedtype Error: Swift.Error
    
    func perform(then handler: @escaping (Result<Response, Error>) -> Void)
}

class RequestQueue {
    private var queue = [() -> Void]()
    private var isPerformingRequest = false
    
    func add<R: Request>(_ request: R,
                         handler: @escaping (Result<R.Response, R.Error>) -> Void) {
        // This closure will capture both the request and its
        // handler, without exposing any of that type information
        // outside of it, providing full type erasure.
        let typeErased = {
            request.perform { [weak self] result in
                handler(result)
                self?.isPerformingRequest = false
                self?.performNextIfNeeded()
            }
        }
        
        queue.append(typeErased)
        performNextIfNeeded()
    }
    
    private func performNextIfNeeded() {
        guard !isPerformingRequest && !queue.isEmpty else {
            return
        }
        
        isPerformingRequest = true
        let closure = queue.removeFirst()
        closure()
    }
}

//: [Next](@next)
