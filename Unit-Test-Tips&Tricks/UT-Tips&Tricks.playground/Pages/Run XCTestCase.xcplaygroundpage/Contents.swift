//: [Previous](@previous)
import XCTest
/*:
 ## Assert Methods
 * **General:** XCTAssert(expression), XCTFail
 * **Equality:** XCTAssertEqual, XCTAssertNotEqual
 * **Truthiness:** XCTAssertTrue, XCTAssertFalse
 * **Nullability:** XCTAssertNil, XCTAssertNotNil
 * **Comparison:** XCTAssertLessThan, XCTAssertGreaterThan, XCTAssertLessThanOrEqual, XCTAssertGreaterThanOrEqual
 * **Erroring:** XCTAssertThrowsError, XCTAssertNoThrow
 */
class SomeTests: XCTestCase {
    var sut: Bool!
    
    override func setUp() {
        sut = true
    }
    override func tearDown() {
        sut = nil
    }
    func testFailure() {
        XCTAssertTrue(sut)
    }
    func testOtherFailure() {
        XCTAssertTrue(sut)
    }
    func testMoreOtherFailure() {
        XCTAssertTrue(sut)
    }
}

class TestObserver: NSObject, XCTestObservation {
    var errorMessages = [String]()
    
    override init() {
        super.init()
        XCTestObservationCenter.shared.addTestObserver(self)
    }

    func testCaseWillStart(_ testCase: XCTestCase) {
        print("testCaseWillStart\(testCase.name)")
    }
    
    func testCaseDidFinish(_ testCase: XCTestCase) {
        print("testCaseDidFinish\(testCase.name)")
    }
    
    func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        errorMessages.append("❌ Fatal error line \(lineNumber): \(description)\(testCase.name))")
    }
    
    func testSuiteDidFinish(_ testSuite: XCTestSuite) {
        print("testSuiteDidFinish\(testSuite.name)")
    }
    
    func testBundleDidFinish(_ testBundle: Bundle) {
        print("testBundleDidFinish\(testBundle.bundlePath)")
    }
}

public extension XCTestSuite {
    override func run() {
        let testObserver = TestObserver()

        super.run()
        
        if testRun?.hasSucceeded ?? false {
            print("✅ All Tests Passed")
        } else if let failureCount = testRun?.failureCount,
            failureCount > 0 {
            dump(testObserver.errorMessages)
        }
    }
}

SomeTests.defaultTestSuite.run()

//: [Next](@next)
