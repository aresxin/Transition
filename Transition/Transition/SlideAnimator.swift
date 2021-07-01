import UIKit

class SlideAnimator: NSObject, Animator {
    var isAnimated: Bool = true

    var slideToLeft: Bool = true

    var duration: TimeInterval = 3


    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }

        startTransition(from: fromVC, to: toVC, context: transitionContext)
    }

    func startTransition(from fromVC: UIViewController, to toVC: UIViewController, context: UIViewControllerContextTransitioning) {
        let container = context.containerView
        let distance = container.bounds.width
        let frame = container.frame
        let initialFrame: CGRect
        let finalFrame: CGRect

        if slideToLeft {
            initialFrame = frame
            finalFrame = frame.offsetBy(dx: -distance, dy: 0)

            fromVC.view.frame = initialFrame
            toVC.view.frame = frame
            container.bringSubviewToFront(fromVC.view)
        } else {
            initialFrame = frame.offsetBy(dx: -distance, dy: 0)
            finalFrame = frame

            fromVC.view.frame = frame
            toVC.view.frame = initialFrame
            container.bringSubviewToFront(toVC.view)
        }

        UIView.animate(withDuration: duration) {
            if self.slideToLeft {
                fromVC.view.frame = finalFrame
            } else {
                toVC.view.frame = finalFrame
            }

        } completion: { [weak context] _ in
            guard let ctx = context else { return }
            ctx.completeTransition(!ctx.transitionWasCancelled)
        }
    }

    public func animationEnded(_ transitionCompleted: Bool) {}
}
