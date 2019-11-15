//: [Previous](@previous)

import XCTest
import Foundation
import CoreMotion

protocol PedometerData {
    var steps: Int { get }
    var distanceTravelled: Double { get }
}
extension CMPedometerData: PedometerData {
    var steps: Int { numberOfSteps.intValue }
    var distanceTravelled: Double { distance?.doubleValue ?? 0 }
}

protocol Pedometer {
    var permissionDeclined: Bool { get }
    var isPedometerAvailable: Bool { get }
    
    func start(dataUpdates: @escaping (PedometerData?, Error?) -> Void,
               eventUpdates: @escaping (Error?) -> Void)
}
extension CMPedometer: Pedometer {
    static var isPedometerAvailable: Bool {
        isStepCountingAvailable() && isDistanceAvailable() && authorizationStatus() != .restricted
    }
    
    var isPedometerAvailable: Bool { CMPedometer.isPedometerAvailable }
    var permissionDeclined: Bool { CMPedometer.authorizationStatus() == .denied }
    
    func start(dataUpdates: @escaping (PedometerData?, Error?) -> Void,
               eventUpdates: @escaping (Error?) -> Void) {
        startUpdates(from: .init()) { data, error in
            dataUpdates(data, error)
        }
        startEventUpdates { event, error in
            eventUpdates(error)
        }
    }
}

class PedometerManager {
    private(set) var isAuthorized = false
    
    let pedometer: Pedometer
    var steps: Int = 0
    var distance: Double = 0
    
    init(pedometer: Pedometer = CMPedometer()) {
        self.pedometer = pedometer
    }
    
    func start() {
        guard pedometer.isPedometerAvailable && !pedometer.permissionDeclined else { return }
        pedometer.start(dataUpdates: handleData,
                        eventUpdates: handleEvents)
    }
    
    func handleData(data: PedometerData?, error: Error?) {
        if let newData = data {
            steps += newData.steps
            distance += newData.distanceTravelled
        }
    }
    
    func handleEvents(error: Error?) {
        let cmError = error
            .map { ($0 as NSError).code }
            .map(UInt32.init)
            .map { CMError(rawValue: $0) }
        
        self.isAuthorized = cmError.map { $0 != CMErrorMotionActivityNotAuthorized } ?? true
    }
}

struct MockData: PedometerData {
    let steps: Int
    let distanceTravelled: Double
}
class MockPedometer: Pedometer {
    private(set) var started = false
    var isPedometerAvailable: Bool = true
    var permissionDeclined: Bool = false
    var error: Error?
    var dataUpdates: ((PedometerData?, Error?) -> Void)?
    
    func start(dataUpdates: @escaping (PedometerData?, Error?) -> Void,
               eventUpdates: @escaping (Error?) -> Void) {
        started = true
        self.dataUpdates = dataUpdates
        eventUpdates(error)
    }
    func sendData(_ data: PedometerData) {
        dataUpdates?(data, nil)
    }
}

class CMPedometerTests: XCTestCase {
    var mockPedometer: MockPedometer!
    var sut: PedometerManager!
    
    override func setUp() {
        super.setUp()
        mockPedometer = MockPedometer()
        sut = PedometerManager(pedometer: mockPedometer)
    }
    override func tearDown() {
        mockPedometer = nil
        sut = nil
    }
    
    func testManager_whenStarted_startsPedometer() {
        //given
        XCTAssertFalse(mockPedometer.started)
        // when
        sut.start()
        // then
        XCTAssertTrue(mockPedometer.started)
    }
    
    func testPedometerNotAvailable_whenStarted_doesNotStart() {
        // given
        mockPedometer.isPedometerAvailable = false
        // when
        sut.start()
        // then
        XCTAssertFalse(mockPedometer.started)
    }
    
    func testPedometerNotAuthorized_whenStarted_doesNotStart() {
        // given
        mockPedometer.permissionDeclined = true
        // when
        sut.start()
        // then
        XCTAssertFalse(mockPedometer.started)
    }
    
    func testManager_whenDeniedAuth() {
        //given
        let expectation = keyValueObservingExpectation(for: sut!,
                                                       keyPath: "isAuthorized",
                                                       expectedValue: false)

        mockPedometer.error = NSError(domain: CMErrorDomain,
                                      code: Int(CMErrorMotionActivityNotAuthorized.rawValue),
                                      userInfo: nil)
        // when
        sut.start()
        // then
        wait(for: [expectation], timeout: 1)
    }
    
    func testManager_whenPedometerUpdate_updatesData() {
        // given
        let data = MockData(steps: 100, distanceTravelled: 10)
        
        // when
        sut.start()
        mockPedometer.sendData(data)
        
        // then
        XCTAssertEqual(sut.steps, 100)
        XCTAssertEqual(sut.distance, 10)
    }
}
CMPedometerTests.defaultTestSuite.run()

//: [Next](@next)
