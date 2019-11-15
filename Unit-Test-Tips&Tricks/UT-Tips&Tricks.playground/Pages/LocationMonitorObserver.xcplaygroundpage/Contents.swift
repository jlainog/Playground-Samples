//: [Previous](@previous)

import XCTest
import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    func locationManager(_ manager: LocationManager, didUpdateLocations locations: [CLLocation])
}
protocol LocationManager {
    var locationManagerDelegate: LocationManagerDelegate? { get set }
    func startUpdatingLocation()
}

extension CLLocationManager: LocationManager {
    var locationManagerDelegate: LocationManagerDelegate? {
        get { delegate as! LocationManagerDelegate? }
        set { delegate = newValue as! CLLocationManagerDelegate? }
    }
}
extension CLLocationManagerDelegate where Self: LocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager(manager, didUpdateLocations: locations)
    }
}

protocol LocationObserver: class {
    func didUpdateLocations(_ locations: [CLLocation])
}

struct LocationManagerFactory {
    static func makeDefault() -> CLLocationManager {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = kCLDistanceFilterNone
        return manager
    }
}

class LocationMonitor: NSObject {
    typealias HashableObserver = LocationObserver & Hashable
    
    var manager: LocationManager
    var lastKnownLocation: CLLocation?
    var observers: Set<AnyHashable> = .init()
    
    internal init(manager: LocationManager = LocationManagerFactory.makeDefault()) {
        self.manager = manager
        super.init()
        self.manager.startUpdatingLocation()
        self.manager.locationManagerDelegate = self
    }
    
    func add<T>(observer: T) where T: HashableObserver {
        observers.insert(observer)
    }
    
    func remove<T>(observer: T) where T: HashableObserver {
        observers.remove(observer)
    }
    
    func contains<T>(observer: T) -> Bool where T: HashableObserver {
        observers.contains(observer)
    }
}
extension LocationMonitor: LocationManagerDelegate {
    func locationManager(_ manager: LocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first
        observers.forEach {
            let observer = ($0 as! LocationObserver)
            observer.didUpdateLocations(locations)
        }
    }
}

class LocationObserverSpy: NSObject, LocationObserver {
    var didCallUpdate = false
    var lastKnownLocation: CLLocation?
    func didUpdateLocations(_ locations: [CLLocation]) {
        didCallUpdate = true
        lastKnownLocation = locations.first
    }
}
class MockLocationManager: LocationManager {
    weak var locationManagerDelegate: LocationManagerDelegate?
    var handleRequestLocation: (() -> CLLocation)?

    func startUpdatingLocation() {
        guard let location = handleRequestLocation?() else { return }
        locationManagerDelegate?.locationManager(self, didUpdateLocations: [location])
    }
}

class LocationObserverTests: XCTestCase {
    var sut: LocationMonitor!
    var spy: LocationObserverSpy!
    var mockManager: MockLocationManager!
    
    override func setUp() {
        super.setUp()
        spy = .init()
        mockManager = .init()
        sut = LocationMonitor(manager: mockManager)
        sut.add(observer: spy)
    }
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    func testLocationManagerFactory_makeDefault() {
        let sut = LocationManagerFactory.makeDefault()
        XCTAssertEqual(sut.distanceFilter, kCLDistanceFilterNone)
        XCTAssertEqual(sut.desiredAccuracy, kCLLocationAccuracyHundredMeters)
    }
    func testMonitor_whenInit_managerExist() {
        XCTAssertNotNil(sut.manager)
    }
    func testMonitor_addObserver() {
        XCTAssertTrue(sut.contains(observer: spy))
    }
    func testMonitor_removeObserver() {
        sut.remove(observer: spy)
        XCTAssertFalse(sut.contains(observer: spy))
    }
    func testMonitor_whenMultipleAddSameObserver_onlyOneIsRegistered() {
        let newSpy = LocationObserverSpy()
        sut.add(observer: newSpy)
        
        let expectedCount = sut.observers.count
        sut.add(observer: spy)
        sut.add(observer: newSpy)
        
        XCTAssertTrue(sut.contains(observer: spy))
        XCTAssertTrue(sut.contains(observer: newSpy))
        XCTAssertEqual(sut.observers.count, expectedCount)
    }
    func testMonitor_whenInit_delegateIsSet() {
        XCTAssertNotNil(sut.manager.locationManagerDelegate)
    }
    func testMonitor_whenLocationUpdated_ObserversGetNotify() {
        let expectedLocation = CLLocation(latitude: 0, longitude: 0)
        let expectation = XCTestExpectation(description: "expectation")
        mockManager.handleRequestLocation = {
            expectation.fulfill()
            return expectedLocation
        }
        
        mockManager.startUpdatingLocation()
        
        XCTAssertTrue(spy.didCallUpdate)
        XCTAssertEqual(spy.lastKnownLocation, expectedLocation)
        XCTAssertEqual(sut.lastKnownLocation, expectedLocation)
        wait(for: [expectation], timeout: 1)
    }
}
LocationObserverTests.defaultTestSuite.run()

//: [Next](@next)

