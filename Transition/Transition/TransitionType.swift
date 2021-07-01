import UIKit

public protocol TransitionType {
    var transitionAnimator: Animator? { get }

    func transitionDidFinished(_ completed: Bool)
}

public extension TransitionType {
    func transitionDidFinished(_ completed: Bool) {}
}

extension TransitionType where Self: UIViewController {
    var transitionContext: TransitionContext? {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.transitionContext) as? TransitionContext {
                return value
            }

            return nil
        }

        set {
            objc_setAssociatedObject(self, &AssociatedKeys.transitionContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var interactiveTransition: PanGestureInteractiveTransition? {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.interactiveTransition) as? PanGestureInteractiveTransition {
                return value
            }

            return nil
        }

        set {
            objc_setAssociatedObject(self, &AssociatedKeys.interactiveTransition, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private extension UIViewController {
    struct AssociatedKeys {
        static var interactiveTransition = "tnteractiveTransition"
        static var transitionContext = "transitionContext"
    }
}
