//: [Previous](@previous)

import CoreLocation
import XCTest

protocol LocationManagerDelegate: class {
    func locationManager(_ manager: LocationManager, didUpdateLocations locations: [CLLocation])
}
protocol LocationManager {
    var locationManagerDelegate: LocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    func requestLocation()
}
extension CLLocationManager: LocationManager {
    var locationManagerDelegate: LocationManagerDelegate? {
        get { delegate as! LocationManagerDelegate? }
        set { delegate = newValue as! CLLocationManagerDelegate? }
    }
}

class LocationProvider: NSObject {
    var locationManager: LocationManager
    var locationCheckCallback: ((CLLocation) -> Void)?
    
    init(locationManager: LocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.locationManagerDelegate = self
    }
    
    func checkCurrentLocation(completion: @escaping (Bool) -> Void) {
        locationCheckCallback = { [unowned self] location in
            completion(self.isPointOfInterest(location))
        }
        locationManager.requestLocation()
    }
    func isPointOfInterest(_ location: CLLocation) -> Bool { true }
}
extension LocationProvider: LocationManagerDelegate {
    func locationManager(_ manager: LocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationCheckCallback?(location)
        locationCheckCallback = nil
    }
}
extension CLLocationManagerDelegate where Self: LocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager(manager, didUpdateLocations: locations)
    }
}

class LocationProviderTests: XCTestCase {
    struct MockLocationManager: LocationManager {
        weak var locationManagerDelegate: LocationManagerDelegate?
        var desiredAccuracy: CLLocationAccuracy = 0
        var handleRequestLocation: (() -> CLLocation)?
        
        func requestLocation() {
            guard let location = handleRequestLocation?() else { return }
            locationManagerDelegate?.locationManager(self, didUpdateLocations: [location])
        }
    }
    
    func testCheckCurrentLocation() {
        var locationManager = MockLocationManager()
        let expectation = XCTestExpectation(description: "expectation")
        locationManager.handleRequestLocation = {
            expectation.fulfill()
            return CLLocation(latitude: 0, longitude: 0)
        }
        let provider = LocationProvider(locationManager: locationManager)

        XCTAssertNotEqual(provider.locationManager.desiredAccuracy, 0)
        XCTAssertNotNil(provider.locationManager.locationManagerDelegate)
        
        let completionExpectation = XCTestExpectation(description: "completionExpectation")
        provider.checkCurrentLocation { (isPointOfInterest) in
            self.XCTAssertTrue(isPointOfInterest)
            completionExpectation.fulfill()
        }
        
        wait(for: [expectation, completionExpectation], timeout: 1)
    }
}
LocationProviderTests.defaultTestSuite.run()

//: [Next](@next)
