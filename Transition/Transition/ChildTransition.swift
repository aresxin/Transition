import UIKit

public protocol ChildTransition: TransitionType {
    var containerView: UIView! { get }
}

public extension ChildTransition where Self: UIViewController {
    func enableInteractiveTransition(threshold: CGFloat = 0, handler: @escaping InteractiveTransitionBeganHandler) {
        let transition = PanGestureInteractiveTransition(view: containerView, recognizedHandler: handler)
        transition.threshold = threshold
        self.interactiveTransition = transition
    }

    func startTransition(from fromViewController: UIViewController?, to toViewController: UIViewController) {
        guard let toView = toViewController.view,
              let container = containerView else {
            return
        }

        toView.translatesAutoresizingMaskIntoConstraints = true
        toView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toView.frame = container.bounds
        container.addSubview(toView)
        addChild(toViewController)

        // 第一次显示 不需要动画
        guard let oldVC: UIViewController = fromViewController else {
            container.addSubview(toView)
            toViewController.didMove(toParent: self)
            return
        }

        oldVC.willMove(toParent: nil)

        // 未指定自定义动画
        guard let animator = self.transitionAnimator, animator.isAnimated else {
            oldVC.view.removeFromSuperview()
            oldVC.removeFromParent()

            container.addSubview(toView)
            toViewController.didMove(toParent: self)
            return
        }

        let context = TransitionContext(from: oldVC, to: toViewController) { [weak self] completed in
            if completed {
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParent()
                toViewController.didMove(toParent: self)
            } else {
                oldVC.view.frame = container.bounds
                toViewController.view.removeFromSuperview()
            }

            animator.animationEnded?(completed)
            self?.transitionContext = nil
            self?.transitionDidFinished(completed)
        }
        context.transitionAnimator = animator
        self.transitionContext = context

        if let transition = self.interactiveTransition, transition.isActive {
            context.startTransition(with: transition)
        } else {
            context.startTransition(with: nil)
        }
    }
}
