import UIKit

class PageCurlAnimator: NSObject, Animator, CAAnimationDelegate {
    var isAnimated: Bool = true

    var slideToLeft: Bool = true

    var duration: TimeInterval = 3
    weak var context: UIViewControllerContextTransitioning?

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
        self.context = context
        let container = context.containerView
        let frame = container.frame
        fromVC.view.frame = frame
        toVC.view.frame = frame
        container.bringSubviewToFront(fromVC.view)

        let animation = CATransition()
        animation.duration = self.duration
        if slideToLeft {
            animation.startProgress = 0
            animation.endProgress = 1
        } else {
            animation.startProgress = 1
            animation.endProgress = 0
        }
        animation.timingFunction = CAMediaTimingFunction(name: .default)
        animation.type = CATransitionType(rawValue: "pageCurl")
        animation.subtype = CATransitionSubtype(rawValue: "fromRight")
        animation.isRemovedOnCompletion = true
        container.layer.add(animation, forKey: "pageCurl")
        animation.delegate = self
    }

    public func animationEnded(_ transitionCompleted: Bool) {}

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let ctx = context else { return }
        ctx.completeTransition(!ctx.transitionWasCancelled)
    }
}
