//: [Previous](@previous)

import XCTest
import PlaygroundSupport

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Receive request with no handler")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
}

struct APILoader {
    static var urlSession: URLSession = .shared
    
    static func load(handler: @escaping () -> Void) {
        urlSession.dataTask(with: URL(string: "www.someApi.com")!) { (_, _, _) in
            handler()
        }.resume()
    }
}

class URLSessionTests: XCTestCase {
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        APILoader.urlSession = URLSession(configuration: configuration)
    }
    
    func testSomeNetworkCall() {
        let data: Data = .init()
        MockURLProtocol.requestHandler = { request in
            self.XCTAssertEqual(request.url, URL(string: "www.someApi.com"))
            return (.init(), data)
        }
        
        let expectation = XCTestExpectation(description: "response")
        APILoader.load {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}

URLSessionTests.defaultTestSuite.run()

extension URLSession {
    static func makeStub() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
    
    static func stub(with handler: ((URLRequest) throws -> (HTTPURLResponse, Data))?) {
        MockURLProtocol.requestHandler = handler
    }
}

class APILoaderTests: XCTestCase {
    override func setUp() {
        APILoader.urlSession = .makeStub()
    }
    
    func testSomeNetworkCall() {
        let data: Data = .init()
        URLSession.stub { request in
            self.XCTAssertEqual(request.url, URL(string: "www.someApi.com"))
            return (.init(), data)
        }
        
        let expectation = XCTestExpectation(description: "response")
        APILoader.load {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
APILoaderTests.defaultTestSuite.run()

//: [Next](@next)
