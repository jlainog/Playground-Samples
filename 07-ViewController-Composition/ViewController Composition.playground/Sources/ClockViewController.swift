import UIKit
import Foundation

public class ClockViewController: UIViewController {
    var timer: Timer!
    var timeLabel = UILabel()
    var formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(timeLabel)
        timeLabel.textAlignment = .center
        timeLabel.frame = view.bounds
        runTimer()
    }
    
    @objc func updateTimer() {
        timeLabel.text = formatter.string(from: Date())
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: (#selector(updateTimer)),
                                     userInfo: nil,
                                     repeats: true)
    }
}
