//: [Previous](@previous)

import UIKit
import Foundation
import PlaygroundSupport

//: # Multiple ViewControllers per Screen

class ContainerViewController: UIViewController {
    
    override func loadView() {
        let stack = UIStackView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        rootStackViewStyle(stack)
        view = stack
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let clockVC = ClockViewController()
        
        addChildToStack(clockVC)
        clockStyle(clockVC.view)
        
        let imageVC = ImageViewController()
        
        addChildToStack(imageVC)
        imageStyle(imageVC.view)
        
        let horizontalVC = HorizontalCollectionViewController()
        
        addChildToStack(horizontalVC)
        horizontalStyle(horizontalVC.view)
    }
    
    func addChildToStack(_ child: UIViewController) {
        addChild(child)
        child.didMove(toParent: self)
        
        guard let stackView = view as? UIStackView else { return }
        stackView.addArrangedSubview(child.view)
    }
}

// Present the view controller in the Live View window
let vc = ContainerViewController()
//vc.preferredContentSize = CGSize(width: 668, height: 375)

PlaygroundPage.current.liveView = vc
vc.view.backgroundColor = .white
//: [Next](@next)

