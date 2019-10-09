import Foundation

public enum Status {
    case downloading, processing, finished
}
public protocol TaskStatusDelegate: class {
    func didChangeStatus(status: Status)
}
public class Task {
    public init() {}
    
    public func retreivePage(for url: URL, completionHandler: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            completionHandler(data)
        }.resume()
//        completionHandler(nil)
    }
    
    public weak var taskDelegate: TaskStatusDelegate?
    public func execute() {
        taskDelegate?.didChangeStatus(status: .downloading)
        taskDelegate?.didChangeStatus(status: .processing)
        taskDelegate?.didChangeStatus(status: .finished)
    }
}

public class MockTaskStatusDelegate: TaskStatusDelegate {
    public var didChangeStatusHandler: ((Status) -> Void)?
    
    public init() {}
    public func didChangeStatus(status: Status) {
        didChangeStatusHandler?(status)
    }
}

public class SecureStorage {
    public init() {}
    public func unlock(_ block: () -> Void) { block() }
    public func save(_ block: () -> Void) { block() }
    public func read(_ block: () -> Void) { block() }
}
