//: [Previous](@previous)

import XCTest

protocol QueueScheduler {
    func asyncAfter(
        deadline: DispatchTime,
        qos: DispatchQoS,
        flags: DispatchWorkItemFlags,
        execute work: @escaping @convention(block) () -> Void
    )
}

extension QueueScheduler {
    func asyncAfter(deadline: DispatchTime,
                    execute work: @escaping @convention(block) () -> Void) {
        asyncAfter(deadline: deadline, qos: .unspecified, flags: [], execute: work)
    }
}

extension DispatchQueue: QueueScheduler {}

struct MockQueueScheduler: QueueScheduler {
    var handleAsyncAfter: ((_ deadline: DispatchTime, _ block: () -> Void) -> Void)?

    func asyncAfter(deadline: DispatchTime, qos: DispatchQoS, flags: DispatchWorkItemFlags, execute work: @escaping @convention(block) () -> Void) {
        handleAsyncAfter?(deadline, work)
    }
}

class FeaturedManager {
    let queue: QueueScheduler
    var didCallNext = false
    
    init(queue: QueueScheduler = DispatchQueue.main) {
        self.queue = queue
    }
    
    func scheduledNext() {
        queue.asyncAfter(deadline: .now() + 10, execute: showNext)
    }
    func showNext() { didCallNext = true }
}

class DispatchQueueTests: XCTestCase {
    func testScheduleNext() {
        var mock = MockQueueScheduler()
        var deadlineObserved: TimeInterval = 0
        mock.handleAsyncAfter = { deadline, block in
            deadlineObserved = deadline.timeIntervalSinceNow
            block()
        }

        let manager = FeaturedManager(queue: mock)
        manager.scheduledNext()
        
        XCTAssertTrue(manager.didCallNext)
        XCTAssertEqual(deadlineObserved, 10, accuracy: 1)
    }
}

extension DispatchTime {
    private var nanoSeconds: UInt64 { 1_000_000_000 }
    var uptimeSeconds: UInt64 { uptimeNanoseconds / nanoSeconds }
    var timeIntervalSinceNow: TimeInterval { .init(uptimeSeconds - DispatchTime.now().uptimeSeconds) }
}

DispatchQueueTests.defaultTestSuite.run()

//: [Next](@next)
