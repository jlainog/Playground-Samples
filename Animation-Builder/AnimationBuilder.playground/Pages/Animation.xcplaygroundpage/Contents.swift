//: [Previous](@previous)

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

public protocol Animation {
    var duration: TimeInterval { get }
    var closure: (UIView) -> Void { get }
}

public enum AnimationMode {
    case inSequence, inParallel
}

public struct AnyAnimation: Animation {
    public let duration: TimeInterval
    public let closure: (UIView) -> Void
    public init(withDuration duration: TimeInterval, animation: @escaping (UIView) -> Void) {
        self.duration = duration
        self.closure = animation
    }
}

public struct Zoom: Animation {
    public let duration: TimeInterval
    public let closure: (UIView) -> Void
    
    public init(to scale: CGFloat, withDuration duration: TimeInterval) {
        self.duration = duration
        self.closure = {
            $0.transform =  CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}

public struct Alpha: Animation {
    public enum State {
        public static let `default` = State.none
        
        case appearing, disappearing, none
        
        public var initialValue: CGFloat {
            return self == .appearing ? 0.0 : 1.0
        }
        public var finalValue: CGFloat {
            return self == .disappearing ? 0.0 : 1.0
        }
    }
    
    public var duration: TimeInterval
    public var closure: (UIView) -> Void
    
    public init(state: Alpha.State = .default, withDuration duration: TimeInterval) {
        self.duration = duration
        self.closure = {
            $0.alpha = state.finalValue
        }
    }
}

extension CGAffineTransform {
    func animate(withDuration duration: TimeInterval,
                 usingCurrentState: Bool = false) -> Animation {
        AnyAnimation(withDuration: duration) {
            if usingCurrentState {
                $0.transform = $0.transform.concatenating(self)
            } else {
                $0.transform = self
            }
        }
    }
}

struct Frame {
    static func move(dx: CGFloat,
                     withDuration duration: TimeInterval) -> Animation {
        AnyAnimation(withDuration: duration) {
            $0.frame.origin.x += dx
        }
    }
    static func move(dy: CGFloat,
                     withDuration duration: TimeInterval) -> Animation {
        AnyAnimation(withDuration: duration) {
            $0.frame.origin.y += dy
        }
    }
    static func move(dx: CGFloat,
                     dy: CGFloat,
                     withDuration duration: TimeInterval) -> Animation {
        AnyAnimation(withDuration: duration) {
            $0.frame.origin.x += dx
            $0.frame.origin.y += dy
        }
    }
    static func size(witdh: CGFloat,
                     height: CGFloat,
                     withDuration duration: TimeInterval) -> Animation {
        AnyAnimation(withDuration: duration) {
            $0.frame.size.width = witdh
            $0.frame.size.height = height
        }
    }
}

@_functionBuilder
public struct AnimationBuilder {
    static func buildBlock(_ animations: Animation...) -> [Animation] {
        animations
    }
}

public extension UIView {
    func animate(_ mode: AnimationMode = .inSequence,
                 @AnimationBuilder block: () -> [Animation]) {
        switch mode {
        case .inParallel: performInParallel(block())
        case .inSequence: performInSequence(block())
        }
    }
    private func performInSequence(_ animations: [Animation],
                                   completionHandler: (() -> Void)? = nil) {
        guard !animations.isEmpty else {
            completionHandler?()
            return
        }
        
        var animations = animations
        let animation = animations.removeFirst()

        UIView.animate(withDuration: animation.duration, animations: {
            animation.closure(self)
        }, completion: { _ in
            self.performInSequence(animations,
                                   completionHandler: completionHandler)
        })
    }
    private func performInParallel(_ animations: [Animation],
                                   completionHandler: (() -> Void)? = nil) {
        guard !animations.isEmpty else {
            return completionHandler?() ?? Void()
        }

        let animationCount = animations.count
        var completionCount = 0

        let animationCompletionHandler = {
            completionCount += 1

            if completionCount == animationCount {
                completionHandler?()
            }
        }

        for animation in animations {
            UIView.animate(withDuration: animation.duration, animations: {
                animation.closure(self)
            }, completion: { _ in
                animationCompletionHandler()
            })
        }
    }
}

let animationView = UIView(frame: .init(x: 50,
                                        y: 50,
                                        width: 50,
                                        height: 50))

animationView.backgroundColor = .red
animationView.alpha = Alpha.State.appearing.initialValue
view.addSubview(animationView)

animationView.animate(.inSequence) {
    Alpha(state: .appearing, withDuration: 1)
    
    Zoom(to: 0.5, withDuration: 2)
    CGAffineTransform
        .identity
        .scaledBy(x: 0.5, y: 0.5)
        .translatedBy(x: 50, y: 0)
        .animate(withDuration: 2)
    Frame
        .move(dx: 50, withDuration: 2)
    CGAffineTransform
        .identity
        .rotated(by: CGFloat.pi)
        .animate(withDuration: 2,
                 usingCurrentState: false)
    CGAffineTransform.identity.animate(withDuration: 2)
    Frame.size(witdh: 100, height: 100, withDuration: 2)

    Alpha(state: .disappearing, withDuration: 1)
}

//: [Next](@next)
