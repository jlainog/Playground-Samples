//: [Previous](@previous)

import Foundation

//: # External specialization

protocol Request {
    associatedtype Response
    associatedtype Error: Swift.Error
    
    typealias Handler = (Result<Response, Error>) -> Void
    
    func perform(then handler: @escaping Handler)
}

struct RequestOperation {
    fileprivate let closure: (@escaping () -> Void) -> Void
    
    func perform(then handler: @escaping () -> Void) {
        closure(handler)
    }
}

extension Request {
    func makeOperation(with handler: @escaping Handler) -> RequestOperation {
        return RequestOperation { finisher in
            // We actually want to capture 'self' here, since otherwise
            // we risk not retaining the underlying request anywhere.
            self.perform { result in
                handler(result)
                finisher()
            }
        }
    }
}

class RequestQueue {
    private var queue = [RequestOperation]()
    private var ongoing: RequestOperation?
    
    // Since the type erasure now happens before a request is
    // passed to the queue, it can simply accept a concrete
    // instance of 'RequestOperation'.
    func add(_ operation: RequestOperation) {
        guard ongoing == nil else {
            queue.append(operation)
            return
        }
        
        perform(operation)
    }
    
    private func perform(_ operation: RequestOperation) {
        ongoing = operation
        
        operation.perform { [weak self] in
            self?.ongoing = nil
                
            // Perform the next request if the queue isn't empty
        }
    }
}

//: [Next](@next)
