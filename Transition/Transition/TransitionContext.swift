import UIKit

typealias TransitionCompletionHandler = (Bool) -> Void

class TransitionContext: NSObject {
    init(from fromViewController: UIViewController, to toViewController: UIViewController, completionHander handler: TransitionCompletionHandler?) {
        fromVC = fromViewController
        toVC = toViewController
        containerView = fromViewController.view.superview!
        completionHandler = handler
        transitionWasCancelled = false
        presentationStyle = .custom
        isAnimated = true
        isInteractive = false
        targetTransform = .identity

        super.init()
    }

    weak var transitionAnimator: Animator?

    private weak var fromVC: UIViewController!
    private weak var toVC: UIViewController!
    private var completionHandler: TransitionCompletionHandler?

    // MARK: - UIViewControllerContextTransitioning
    let containerView: UIView
    let isAnimated: Bool
    let presentationStyle: UIModalPresentationStyle
    var isInteractive: Bool
    var transitionWasCancelled: Bool
    let targetTransform: CGAffineTransform

    func startTransition(with interactionTransition: PanGestureInteractiveTransition?) {
        guard let animator = transitionAnimator else {
            return
        }

        if let transition = interactionTransition {
            transition.animator = animator
            transition.startInteractiveTransition(self)
        } else {
            animator.animateTransition(using: self)
        }
    }
}

extension TransitionContext: UIViewControllerContextTransitioning {
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return (key == .from) ? fromVC : toVC
    }

    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return (key == .from) ? fromVC.view : toVC.view
    }

    func initialFrame(for vc: UIViewController) -> CGRect {
        return .zero
    }

    func finalFrame(for vc: UIViewController) -> CGRect {
        return .zero
    }

    func pauseInteractiveTransition() {}

    func updateInteractiveTransition(_ percentComplete: CGFloat) {}

    func finishInteractiveTransition() {
        transitionWasCancelled = false
    }

    func cancelInteractiveTransition() {
        transitionWasCancelled = true
    }

    func completeTransition(_ didComplete: Bool) {
        completionHandler?(didComplete)
        completionHandler = nil
    }
}
