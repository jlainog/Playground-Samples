import XCTest

protocol TimerScheduler {
    func add(_ timer: Timer, forMode mode: RunLoop.Mode)
}
extension RunLoop: TimerScheduler {}

struct MockTimerScheduler: TimerScheduler {
    var handleAddTimer: ((_ timer: Timer) -> Void)?
    
    func add(_ timer: Timer, forMode mode: RunLoop.Mode) {
        handleAddTimer?(timer)
    }
}

class FeaturedManager {
    let timeScheduler: TimerScheduler
    
    init(timeScheduler: TimerScheduler = RunLoop.current) {
        self.timeScheduler = timeScheduler
    }
    
    func scheduledNext() {
        let timer = Timer(timeInterval: 10, repeats: false) { [weak self] (timer) in
            self?.showNext()
        }
        timeScheduler.add(timer, forMode: .default)
    }
    func showNext() {}
}

class TimerTests: XCTestCase {
    func testScheduleNextPlace() {
        var mock = MockTimerScheduler()
        var timerDelay: TimeInterval = 0
        mock.handleAddTimer = { timer in
            timerDelay = timer.fireDate.timeIntervalSinceNow
            timer.fire()
        }
        
        let manager = FeaturedManager(timeScheduler: mock)
        manager.scheduledNext()
        
        XCTAssertEqual(timerDelay, 10, accuracy: 1)
    }
}
