/*:
# ViewController Composition
 

 ### Implementing a Container View Controller
A custom UIViewController subclass can also act as a container view controller. A container view controller manages the presentation of content of other view controllers it owns, also known as its child view controllers. A child's view can be presented as-is or in conjunction with views owned by the container view controller.

Your container view controller subclass should declare a public interface to associate its children. The nature of these methods is up to you and depends on the semantics of the container you are creating. You need to decide how many children can be displayed by your view controller at once, when those children are displayed, and where they appear in your view controller's view hierarchy. Your view controller class defines what relationships, if any, are shared by the children. By establishing a clean public interface for your container, you ensure that children use its capabilities logically, without accessing too many private details about how your container implements the behavior.

Your container view controller must associate a child view controller with itself before adding the child's root view to the view hierarchy. This allows iOS to properly route events to child view controllers and the views those controllers manage. Likewise, after it removes a child's root view from its view hierarchy, it should disconnect that child view controller from itself. To make or break these associations, your container calls specific methods defined by the base class. These methods are not intended to be called by clients of your container class; they are to be used only by your container's implementation to provide the expected containment behavior.

Here are the essential methods you might need to call:

addChild(_:)

removeFromParent()

willMove(toParent:)

didMove(toParent:)
*/
import UIKit

extension UIViewController {
    ///: Add a Child ViewController and Child view's to the Itself (Container View Controller) properly
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    ///: Add a Child ViewController the Itself and the Child view's to view argument
    func add(_ child: UIViewController, to superview: UIView) {
        add(child)
        child.view.removeFromSuperview()
        superview.addSubview(child.view)
    }
    
    ///: Remove the ViewController from the parent (Container View Controller) properly.
    func remove() {
        guard parent != nil else {
            return
        }
    
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
//: [Next](@next)
