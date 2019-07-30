//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
}
// Present the view controller in the Live View window
let vc = MyViewController()
PlaygroundPage.current.liveView = vc
let view = vc.view!


public protocol TransformAnimation {
    var transform : CGAffineTransform { get }
}

public struct Zoom : TransformAnimation {
    public let transform: CGAffineTransform
    
    public init(_ scale: CGFloat) {
        transform =  CGAffineTransform(scaleX: scale, y: scale)
    }
}

public struct Rotate : TransformAnimation {
    public let transform: CGAffineTransform
    
    public init(angle: CGFloat) {
        transform = CGAffineTransform(rotationAngle: angle)
    }
}

public struct Translation : TransformAnimation {
    public let transform: CGAffineTransform
    
    public init(x: CGFloat) {
        transform = CGAffineTransform(translationX: x, y: 0)
    }
    
    public init(y: CGFloat) {
        transform = CGAffineTransform(translationX: 0, y: y)
    }
    
    public init(x: CGFloat, y: CGFloat) {
        transform = CGAffineTransform(translationX: x, y: y)
    }
}

@_functionBuilder
public struct TransformAnimationBuilder {
    static func buildBlock(_ animations: TransformAnimation...) -> TransformAnimation {
        MultipleTransformAnimation(animations)
    }
}

public struct MultipleTransformAnimation : TransformAnimation {
    public let transform: CGAffineTransform
    
    public init(_ array: [TransformAnimation]) {
        transform = array.reduce(CGAffineTransform.identity) { result, animation in
            result.concatenating(animation.transform)
        }
    }
    public init(@TransformAnimationBuilder block: () -> TransformAnimation) {
        transform = block().transform
    }
}

MultipleTransformAnimation {
    Zoom(0.5)
    Rotate(angle: 180)
}

public extension UIView {
    func animate(withDuration duration: TimeInterval,
                 @TransformAnimationBuilder animations: () -> TransformAnimation) {
        let transform = animations().transform
        UIView.animate(withDuration: duration, animations: {
            self.transform = transform
        }, completion: nil)
    }
}

let animationView = UIView(frame: .init(x: 0,
                                        y: 0,
                                        width: 50,
                                        height: 50))

animationView.backgroundColor = .red
animationView.alpha = 1
view.addSubview(animationView)

animationView.animate(withDuration: 1) {
    Zoom(0.5)
    Rotate(angle: 180)
    Translation(x: 50)
}

@_functionBuilder
public struct CGAffineTransformBuilder {
    static func buildBlock(_ transforms: CGAffineTransform...) -> CGAffineTransform {
        transforms.reduce(CGAffineTransform.identity) { result, transform in
            result.concatenating(transform)
        }
    }
}

func transform(@CGAffineTransformBuilder block: () -> CGAffineTransform) -> CGAffineTransform {
    block()
}

transform {
    CGAffineTransform(scaleX: 0.5, y: 0.5)
    CGAffineTransform(rotationAngle: 180)
    CGAffineTransform(translationX: 5, y: 10)
}

//UIView.animate(withDuration: 1) {
//    animationView.transform = transform {
//        CGAffineTransform(scaleX: 0.5, y: 0.5)
//        CGAffineTransform(rotationAngle: 180)
//        CGAffineTransform(translationX: 5, y: 10)
//    }
//}
//UIView.animate(withDuration: 1) {
//    animationView.transform = CGAffineTransform
//        .identity
//        .scaledBy(x: 0.5, y: 0.5)
//        .translatedBy(x: 5, y: 10)
//        .rotated(by: 180)
//}


