//: [Previous](@previous)

import XCTest
import Foundation

protocol URLOpener {
    func canOpenURL(_ url: URL) -> Bool

    func open(_ url: URL,
              options: [UIApplication.OpenExternalURLOptionsKey : Any],
              completionHandler completion: ((Bool) -> Void)?)
}
extension UIApplication: URLOpener {}

struct DefaultURLOpener {
    let opener: URLOpener
    
    init(opener: URLOpener = UIApplication.shared) {
        self.opener = opener
    }
    
    func open(_ url: URL) {
        if opener.canOpenURL(url) {
            opener.open(url, options: [:], completionHandler: nil)
        }
    }
}

class URLOpenerTests: XCTestCase {
    class MockURLOpening: URLOpener {
        var canOpen = false
        var openedURL: URL?
        
        func canOpenURL(_ url: URL) -> Bool { canOpen }
        
        func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?) {
            openedURL = url
        }
    }
    
    func testURLOpener() {
        let mock = MockURLOpening()
        mock.canOpen = true
        
        let documentOpener = DefaultURLOpener(opener: mock)
        let url = URL(string: "www.someApi.com")!
        documentOpener.open(url)
        
        XCTAssertEqual(mock.openedURL, url)
    }
}
URLOpenerTests.defaultTestSuite.run()

//: [Next](@next)
