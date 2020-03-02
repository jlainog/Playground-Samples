//: [Previous](@previous)

import XCTest

class ExampleTests: XCTestCase {
    func testDownloadWebData() {
        let url = URL(string: "https://apple.com")!
        let task = Task()

        // Create an expectation for a background download task.
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        task.retreivePage(for: url) { (data) in
            // Fulfill the expectation to indicate that the background task has finished successfully.
            expectation.fulfill()
            self.XCTAssertNotNil(data, "No data was downloaded.")

        }

        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testExecuteStates() {
        var statusOrder = [Status]()
        let mockDelegate = MockTaskStatusDelegate()

        // Create an expectation for the status change handler.
        let expectation = XCTestExpectation(description: "expectation")

        // Set expectation fulfillment count to 3.
        expectation.expectedFulfillmentCount = 3
        mockDelegate.didChangeStatusHandler = { status in
            // Fulfill the expectation
            expectation.fulfill()

            statusOrder.append(status)
        }

        let task = Task()
        task.taskDelegate = mockDelegate
        task.execute()

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(statusOrder, [.downloading, .processing, .finished])
    }

    func testDelegateNotCallWhenRetreivingPage() {
        let mockDelegate = MockTaskStatusDelegate()
        
        // Expectation for the closure we'e expecting to be cancelled
        let cancelExpectation = expectation(description: "Cancel")
        cancelExpectation.isInverted = true
        mockDelegate.didChangeStatusHandler = { status in
            cancelExpectation.fulfill()
        }
        
        let task = Task()
        task.taskDelegate = mockDelegate
        
        // Expectation for the closure we're expecting to be completed
        let completedExpectation = expectation(description: "Completed")
        task.retreivePage(for: URL(string: "https://apple.com")!) { (data) in
            // Fulfill the expectation to indicate that the background task has finished successfully.
            completedExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testMultipleExpectations() {
        let storage = SecureStorage()

        let unlockExpectation = XCTestExpectation(description: "secure storage is unlocked")
        storage.unlock {
            unlockExpectation.fulfill()
        }
        wait(for: [unlockExpectation], timeout: 1)

        let saveExpectation = XCTestExpectation(description: "value is saved")
        storage.save {
            saveExpectation.fulfill()
        }
        wait(for: [saveExpectation], timeout: 1)

        let readExpectation = XCTestExpectation(description: "value is read")
        storage.read {
            readExpectation.fulfill()
        }
        wait(for: [readExpectation], timeout: 1)

//        wait(for: [unlockExpectation, saveExpectation, readExpectation],
//             timeout: 1,
//             enforceOrder: true)
    }
}

ExampleTests.defaultTestSuite.run()

//: [Next](@next)
