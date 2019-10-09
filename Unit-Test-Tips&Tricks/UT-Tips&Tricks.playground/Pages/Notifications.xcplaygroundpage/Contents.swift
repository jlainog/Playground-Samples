//: [Previous](@previous)

import Foundation
import XCTest

class LocationHandler {
    var observer: AnyObject?
    let notificationCenter: NotificationCenter
    
    init(_ notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        observer = notificationCenter.addObserver(forName: .init("LocationChanged"),
                           object: nil,
                           queue: .main)
        { [weak self] (_) in
            self?.handleChange()
        }
    }
    
    var didHandleNotification = false
    func handleChange() {
        didHandleNotification = true
    }
}

class LocationHandlerTests: XCTestCase {
    func testNoficationHandled() {
        let notificationCenter = NotificationCenter()
        let handler = LocationHandler(notificationCenter)
        XCTAssertFalse(handler.didHandleNotification)
        
        notificationCenter.post(name: .init("LocationChanged"), object: nil)
        XCTAssertTrue(handler.didHandleNotification)
    }
}
LocationHandlerTests.defaultTestSuite.run()

class LocationProvider {
    let notificationCenter: NotificationCenter
    
    init(_ notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }
    
    func notifyLocationChange() {
        notificationCenter.post(name: .init("LocationChanged"), object: nil)
    }
}

class LocationProviderTests: XCTestCase {
    func testNotificationPosted() {
        let notificationCenter = NotificationCenter()
        let provider = LocationProvider(notificationCenter)
        let expectation = XCTNSNotificationExpectation(name: .init("LocationChanged"),
                                                       object: provider,
                                                       notificationCenter: notificationCenter)
        
        provider.notifyLocationChange()
        wait(for: [expectation], timeout: 0)
    }
}
LocationProviderTests.defaultTestSuite.run()

//: [Next](@next)
