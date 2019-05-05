//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

extension UIViewController {
    func add(_ child: UIViewController) {
//        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

class ErrorViewController: UIViewController {
    var reloadHandler: () -> Void = {}
}

class ListViewController: UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItems()
    }
}

private extension ListViewController {
    func loadItems() {
        let loadingViewController = LoadingViewController()
        
        add(loadingViewController)
        loadingViewController.view.frame = view.bounds
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let label = UILabel()
            label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
            label.text = "Hello World!"
            label.textColor = .black
            
            self.view.addSubview(label)
            loadingViewController.remove()
        }
    }
    
    func handle(_ error: Error) {
        let errorViewController = ErrorViewController()
        
        errorViewController.reloadHandler = { [weak self] in
            self?.loadItems()
        }
        
        add(errorViewController)
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = ListViewController()


