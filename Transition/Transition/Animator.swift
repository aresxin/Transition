import UIKit

public protocol Animator: UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval { get }

    var isAnimated: Bool { get }

    func startTransition(from fromVC: UIViewController, to toVC: UIViewController, context: UIViewControllerContextTransitioning)
}

public extension Animator {
    var duration: TimeInterval {
        return 0.7
    }
}
