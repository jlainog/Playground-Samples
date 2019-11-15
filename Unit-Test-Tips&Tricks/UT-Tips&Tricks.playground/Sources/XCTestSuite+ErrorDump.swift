import XCTest

class TestObserver: NSObject, XCTestObservation {
    var errorMessages = [String]()
    
    override init() {
        super.init()
        XCTestObservationCenter.shared.addTestObserver(self)
    }

    func testCaseWillStart(_ testCase: XCTestCase) {
//        print("testCaseWillStart\(testCase.name)")
    }
    
    func testCaseDidFinish(_ testCase: XCTestCase) {
//        print("testCaseDidFinish\(testCase.name)")
    }
    
    func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        errorMessages.append("❌ Fatal error line \(lineNumber): \(description)\(testCase.name))")
    }
    
    func testSuiteDidFinish(_ testSuite: XCTestSuite) {
//        print("testSuiteDidFinish\(testSuite.name)")
    }
    
    func testBundleDidFinish(_ testBundle: Bundle) {
//        print("testBundleDidFinish\(testBundle.bundlePath)")
    }
}

extension XCTestSuite {
    override open func run() {
        let testObserver = TestObserver()
        XCTestObservationCenter.shared.addTestObserver(testObserver)

        super.run()
        
        if testRun?.hasSucceeded ?? false {
            print("✅ All Tests Passed")
        } else if let failureCount = testRun?.failureCount,
            failureCount > 0 {
            dump(testObserver.errorMessages)
        }
    }
}
