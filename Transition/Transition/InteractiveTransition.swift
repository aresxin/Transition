import UIKit

class InteractiveTransition: NSObject, UIViewControllerInteractiveTransitioning {
    override init() {
        percent = 0
        animator = nil
    }

    weak var animator: Animator?

    private var duration: CGFloat {
        guard let animator = self.animator else {
            return 0
        }

        return CGFloat(animator.transitionDuration(using: transitioning))
    }

    private(set) var percent: CGFloat

    private weak var transitioning: UIViewControllerContextTransitioning?
    private weak var displayLink: CADisplayLink?

    func updateTransition(with value: CGFloat) {
        let newPercent = max(min(value, 1), 0)
        guard self.percent != newPercent, let transitioning = self.transitioning else {
            return
        }

        self.percent = value
        let timeOffset = value*duration
        transitioning.containerView.layer.timeOffset = CFTimeInterval(timeOffset)
        transitioning.updateInteractiveTransition(value)
    }

    func cancelTransition() {
        guard let transitioning = self.transitioning else {
            return
        }

        let displayLink = CADisplayLink(target: self, selector: #selector(tickCancelAnimation(displayLink:)))
        displayLink.add(to: .main, forMode: .common)
        transitioning.cancelInteractiveTransition()
    }

    func finishTransition() {
        guard let transitioning = self.transitioning else {
            return
        }

        let layer = transitioning.containerView.layer
        let pausedTime = layer.timeOffset
        layer.speed = 1
        layer.timeOffset = 0
        layer.beginTime = 0
        let time = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = time

        transitioning.finishInteractiveTransition()
    }

    // MARK: - UIViewControllerInteractiveTransitioning
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.containerView.layer.speed = 0
        percent = 0
        animator?.animateTransition(using: transitionContext)

        self.transitioning = transitionContext
    }
}

private extension InteractiveTransition {
    @objc func tickCancelAnimation(displayLink: CADisplayLink) {
        guard let transitioning = self.transitioning else {
            displayLink.invalidate()
            self.displayLink = nil
            return
        }

        let layer = transitioning.containerView.layer
        let timeOffset = layer.timeOffset - displayLink.duration
        if timeOffset >= 0 {
            layer.timeOffset = timeOffset
        } else {
            self.displayLink?.invalidate()
            layer.speed = 1
        }
    }
}
