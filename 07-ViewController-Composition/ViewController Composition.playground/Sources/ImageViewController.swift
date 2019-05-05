import UIKit

public class ImageViewController: UIViewController {
    public var image: UIImage? {
        willSet {
            guard let imageView = view as? UIImageView else {
                return
            }
            
            imageView.image = newValue
        }
    }
    
    public override func loadView() {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        view = imageView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
        image = #imageLiteral(resourceName: "Seaport.jpeg")
    }
}
